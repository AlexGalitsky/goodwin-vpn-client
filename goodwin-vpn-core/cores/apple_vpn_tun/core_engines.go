package main

import (
	"encoding/binary"
	"encoding/json"
	"fmt"
	"io"
	"net"
	"sync"

	"github.com/VanyaKrotov/xray_cshare/xray"
	"github.com/apernet/hysteria/core/v2/client"
	"github.com/txthinking/socks5"
	xcore "github.com/xtls/xray-core/core"
)

var (
	coreMu     sync.Mutex
	activeCore string // "xray" | "hysteria2"
	xrayInst   *xcore.Instance
	hyClient   client.Client
	hyLn       net.Listener
)

type hyFileConfig struct {
	Server string `json:"server"`
	Auth   string `json:"auth"`
	TLS    *struct {
		SNI      string `json:"sni"`
		Insecure bool   `json:"insecure"`
	} `json:"tls"`
	SOCKS5 *struct {
		Listen   string `json:"listen"`
		Username string `json:"username"`
		Password string `json:"password"`
	} `json:"socks5"`
	Obfs *struct {
		Type string `json:"type"`
	} `json:"obfs"`
}

func startCore(kind, configJSON string, socksPort int) error {
	switch kind {
	case "xray":
		return startXray(configJSON)
	case "hysteria2", "hysteria":
		return startHysteria(configJSON, socksPort)
	default:
		return fmt.Errorf("unknown core %q", kind)
	}
}

func startXray(configJSON string) error {
	coreMu.Lock()
	defer coreMu.Unlock()
	if xrayInst != nil {
		return nil
	}
	inst, err := xray.Start(configJSON)
	if err != nil {
		return fmt.Errorf("xray: %s", err.Message)
	}
	xrayInst = inst
	activeCore = "xray"
	return nil
}

func startHysteria(configJSON string, socksPort int) error {
	coreMu.Lock()
	defer coreMu.Unlock()
	if hyLn != nil {
		return nil
	}

	var cfg hyFileConfig
	if err := json.Unmarshal([]byte(configJSON), &cfg); err != nil {
		return fmt.Errorf("json: %w", err)
	}
	if cfg.Server == "" || cfg.Auth == "" {
		return fmt.Errorf("server and auth are required")
	}
	if cfg.Obfs != nil {
		return fmt.Errorf("obfs is not supported in this wrapper yet")
	}
	listen := fmt.Sprintf("127.0.0.1:%d", socksPort)
	if cfg.SOCKS5 != nil && cfg.SOCKS5.Listen != "" {
		listen = cfg.SOCKS5.Listen
	}
	socksUser, socksPass := "", ""
	if cfg.SOCKS5 != nil {
		socksUser = cfg.SOCKS5.Username
		socksPass = cfg.SOCKS5.Password
	}
	if socksUser == "" || socksPass == "" {
		return fmt.Errorf("socks5 username and password are required")
	}

	host, _, err := net.SplitHostPort(cfg.Server)
	if err != nil {
		return fmt.Errorf("server address: %w", err)
	}
	// Prefer explicit SNI (hostname) — after anti-loop pin server is an IP.
	sni := host
	insecure := false
	if cfg.TLS != nil {
		if cfg.TLS.SNI != "" {
			sni = cfg.TLS.SNI
		}
		insecure = cfg.TLS.Insecure
	}

	udpAddr, err := net.ResolveUDPAddr("udp", cfg.Server)
	if err != nil {
		return fmt.Errorf("resolve: %w", err)
	}

	hy, _, err := client.NewClient(&client.Config{
		ServerAddr: udpAddr,
		Auth:       cfg.Auth,
		TLSConfig: client.TLSConfig{
			ServerName:         sni,
			InsecureSkipVerify: insecure,
		},
	})
	if err != nil {
		return fmt.Errorf("handshake: %w", err)
	}

	ln, err := net.Listen("tcp", listen)
	if err != nil {
		_ = hy.Close()
		return fmt.Errorf("socks listen: %w", err)
	}

	hyClient = hy
	hyLn = ln
	activeCore = "hysteria2"
	go func() { _ = serveHySOCKS(ln, hy, socksUser, socksPass) }()
	return nil
}

func stopCore() {
	coreMu.Lock()
	kind := activeCore
	inst := xrayInst
	ln := hyLn
	hy := hyClient
	xrayInst = nil
	hyLn = nil
	hyClient = nil
	activeCore = ""
	coreMu.Unlock()

	if kind == "xray" && inst != nil {
		xray.Stop(inst)
	}
	if ln != nil {
		_ = ln.Close()
	}
	if hy != nil {
		_ = hy.Close()
	}
}

func serveHySOCKS(ln net.Listener, hy client.Client, user, pass string) error {
	for {
		conn, err := ln.Accept()
		if err != nil {
			return err
		}
		go handleHySOCKS(conn, hy, user, pass)
	}
}

func handleHySOCKS(conn net.Conn, hy client.Client, user, pass string) {
	ok, _ := negotiateSOCKS(conn, user, pass)
	if !ok {
		_ = conn.Close()
		return
	}
	req, err := socks5.NewRequestFrom(conn)
	if err != nil {
		_ = conn.Close()
		return
	}
	switch req.Cmd {
	case socks5.CmdConnect:
		handleHyTCP(conn, req, hy)
	case socks5.CmdUDP:
		// Required for tun2socks DNS (UDP) — without this the tunnel kills
		// connectivity and the UI reconnect-loops.
		handleHyUDP(conn, hy)
	default:
		_ = hyReply(conn, socks5.RepCommandNotSupported)
		_ = conn.Close()
	}
}

func handleHyTCP(conn net.Conn, req *socks5.Request, hy client.Client) {
	defer conn.Close()
	remote, err := hy.TCP(req.Address())
	if err != nil {
		_ = hyReply(conn, socks5.RepHostUnreachable)
		return
	}
	defer remote.Close()
	_ = hyReply(conn, socks5.RepSuccess)
	errCh := make(chan struct{}, 2)
	go func() {
		_, _ = io.Copy(remote, conn)
		errCh <- struct{}{}
	}()
	go func() {
		_, _ = io.Copy(conn, remote)
		errCh <- struct{}{}
	}()
	<-errCh
}

func handleHyUDP(conn net.Conn, hy client.Client) {
	defer conn.Close()
	// Bind loopback IPv4. Advertising the TCP LocalAddr (or 0.0.0.0) makes
	// tun2socks/gVisor send ASSOCIATE datagrams where the extension never
	// receives them — DNS dies and the UI reconnect-loops on iOS.
	udpConn, err := net.ListenUDP("udp4", &net.UDPAddr{IP: net.IPv4(127, 0, 0, 1), Port: 0})
	if err != nil {
		_ = hyReply(conn, socks5.RepServerFailure)
		return
	}
	defer udpConn.Close()
	hyUDP, err := hy.UDP()
	if err != nil {
		_ = hyReply(conn, socks5.RepServerFailure)
		return
	}
	defer hyUDP.Close()
	bound := udpConn.LocalAddr().(*net.UDPAddr)
	_ = hyUDPReply(conn, &net.UDPAddr{IP: net.IPv4(127, 0, 0, 1), Port: bound.Port})

	var clientAddr *net.UDPAddr
	buf := make([]byte, 4096)
	go func() {
		_, _ = io.Copy(io.Discard, conn)
		_ = udpConn.Close()
	}()
	for {
		n, cAddr, err := udpConn.ReadFromUDP(buf)
		if err != nil {
			return
		}
		d, err := socks5.NewDatagramFromBytes(buf[:n])
		if err != nil || d.Frag != 0 {
			continue
		}
		if clientAddr == nil {
			clientAddr = cAddr
			go func() {
				for {
					bs, from, err := hyUDP.Receive()
					if err != nil {
						_ = udpConn.Close()
						return
					}
					atyp, addr, port, err := socks5.ParseAddress(from)
					if err != nil {
						continue
					}
					if atyp == socks5.ATYPDomain {
						addr = addr[1:]
					}
					out := socks5.NewDatagram(atyp, addr, port, bs)
					_, _ = udpConn.WriteToUDP(out.Bytes(), clientAddr)
				}
			}()
		} else if !clientAddr.IP.Equal(cAddr.IP) || clientAddr.Port != cAddr.Port {
			continue
		}
		_ = hyUDP.Send(d.Data, d.Address())
	}
}

func hyReply(conn net.Conn, rep byte) error {
	p := socks5.NewReply(rep, socks5.ATYPIPv4, []byte{0, 0, 0, 0}, []byte{0, 0})
	_, err := p.WriteTo(conn)
	return err
}

func hyUDPReply(conn net.Conn, addr *net.UDPAddr) error {
	var atyp byte
	var bndAddr []byte
	if ip4 := addr.IP.To4(); ip4 != nil {
		atyp = socks5.ATYPIPv4
		bndAddr = ip4
	} else {
		atyp = socks5.ATYPIPv6
		bndAddr = addr.IP
	}
	bndPort := make([]byte, 2)
	binary.BigEndian.PutUint16(bndPort, uint16(addr.Port))
	p := socks5.NewReply(socks5.RepSuccess, atyp, bndAddr, bndPort)
	_, err := p.WriteTo(conn)
	return err
}
