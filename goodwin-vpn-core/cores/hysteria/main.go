package main

/*
#include <stdlib.h>
#include <string.h>
*/
import "C"

import (
	"encoding/binary"
	"encoding/json"
	"fmt"
	"io"
	"net"
	"sync"
	"unsafe"

	"github.com/apernet/hysteria/core/v2/client"
	"github.com/txthinking/socks5"
)

const (
	packOffset = 8
	typeError  = 1
	typePlain  = 3
)

type fileConfig struct {
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
		Type       string `json:"type"`
		Salamander *struct {
			Password string `json:"password"`
		} `json:"salamander"`
	} `json:"obfs"`
}

type hyInstance struct {
	client client.Client
	ln     net.Listener
}

var (
	mu        sync.Mutex
	instances = map[string]*hyInstance{}
)

func pack(status uint32, contentType uint16, body string) unsafe.Pointer {
	total := packOffset + len(body) + 1
	ptr := C.malloc(C.size_t(total))
	if ptr == nil {
		return nil
	}
	buf := unsafe.Slice((*byte)(ptr), total)
	binary.LittleEndian.PutUint32(buf[0:4], status)
	binary.LittleEndian.PutUint16(buf[4:6], contentType)
	copy(buf[packOffset:], []byte(body))
	buf[total-1] = 0
	return ptr
}

func packOK(msg string) unsafe.Pointer   { return pack(0, typePlain, msg) }
func packErr(msg string) unsafe.Pointer { return pack(1, typeError, msg) }

//export FreePointer
func FreePointer(ptr unsafe.Pointer) {
	if ptr != nil {
		C.free(ptr)
	}
}

//export GetHysteriaVersion
func GetHysteriaVersion() unsafe.Pointer {
	return packOK("hysteria2-cshare")
}

//export Start
func Start(cUUID, cJSON *C.char) unsafe.Pointer {
	uuid := C.GoString(cUUID)
	raw := C.GoString(cJSON)

	mu.Lock()
	if _, ok := instances[uuid]; ok {
		mu.Unlock()
		return packErr("hysteria already started")
	}
	mu.Unlock()

	var cfg fileConfig
	if err := json.Unmarshal([]byte(raw), &cfg); err != nil {
		return packErr(fmt.Sprintf("json: %v", err))
	}
	if cfg.Server == "" || cfg.Auth == "" {
		return packErr("server and auth are required")
	}
	listen := "127.0.0.1:10808"
	if cfg.SOCKS5 != nil && cfg.SOCKS5.Listen != "" {
		listen = cfg.SOCKS5.Listen
	}
	socksUser, socksPass := "", ""
	if cfg.SOCKS5 != nil {
		socksUser = cfg.SOCKS5.Username
		socksPass = cfg.SOCKS5.Password
	}
	if socksUser == "" || socksPass == "" {
		return packErr("socks5 username and password are required")
	}
	if cfg.Obfs != nil {
		return packErr("obfs is not supported in this wrapper yet")
	}

	host, _, err := net.SplitHostPort(cfg.Server)
	if err != nil {
		return packErr(fmt.Sprintf("server address: %v", err))
	}
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
		return packErr(fmt.Sprintf("resolve: %v", err))
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
		return packErr(fmt.Sprintf("handshake: %v", err))
	}

	ln, err := net.Listen("tcp", listen)
	if err != nil {
		_ = hy.Close()
		return packErr(fmt.Sprintf("socks listen: %v", err))
	}

	inst := &hyInstance{client: hy, ln: ln}
	mu.Lock()
	instances[uuid] = inst
	mu.Unlock()

	go func() {
		_ = serveSOCKS(ln, hy, socksUser, socksPass)
	}()

	return packOK("started")
}

//export Stop
func Stop(cUUID *C.char) {
	uuid := C.GoString(cUUID)
	mu.Lock()
	inst, ok := instances[uuid]
	if ok {
		delete(instances, uuid)
	}
	mu.Unlock()
	if !ok {
		return
	}
	_ = inst.ln.Close()
	_ = inst.client.Close()
}

//export IsStarted
func IsStarted(cUUID *C.char) C.int {
	uuid := C.GoString(cUUID)
	mu.Lock()
	defer mu.Unlock()
	if _, ok := instances[uuid]; ok {
		return 1
	}
	return 0
}

func serveSOCKS(ln net.Listener, hy client.Client, user, pass string) error {
	for {
		conn, err := ln.Accept()
		if err != nil {
			return err
		}
		go handleSOCKS(conn, hy, user, pass)
	}
}

func handleSOCKS(conn net.Conn, hy client.Client, user, pass string) {
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
		handleTCP(conn, req, hy)
	case socks5.CmdUDP:
		handleUDP(conn, hy)
	default:
		_ = sendSimpleReply(conn, socks5.RepCommandNotSupported)
		_ = conn.Close()
	}
}

func handleTCP(conn net.Conn, req *socks5.Request, hy client.Client) {
	defer conn.Close()
	rConn, err := hy.TCP(req.Address())
	if err != nil {
		_ = sendSimpleReply(conn, socks5.RepHostUnreachable)
		return
	}
	defer rConn.Close()
	_ = sendSimpleReply(conn, socks5.RepSuccess)
	errCh := make(chan struct{}, 2)
	go func() {
		_, _ = io.Copy(rConn, conn)
		errCh <- struct{}{}
	}()
	go func() {
		_, _ = io.Copy(conn, rConn)
		errCh <- struct{}{}
	}()
	<-errCh
}

func handleUDP(conn net.Conn, hy client.Client) {
	defer conn.Close()
	host, _, err := net.SplitHostPort(conn.LocalAddr().String())
	if err != nil {
		_ = sendSimpleReply(conn, socks5.RepServerFailure)
		return
	}
	udpAddr, err := net.ResolveUDPAddr("udp", net.JoinHostPort(host, "0"))
	if err != nil {
		_ = sendSimpleReply(conn, socks5.RepServerFailure)
		return
	}
	udpConn, err := net.ListenUDP("udp", udpAddr)
	if err != nil {
		_ = sendSimpleReply(conn, socks5.RepServerFailure)
		return
	}
	defer udpConn.Close()
	hyUDP, err := hy.UDP()
	if err != nil {
		_ = sendSimpleReply(conn, socks5.RepServerFailure)
		return
	}
	defer hyUDP.Close()
	_ = sendUDPReply(conn, udpConn.LocalAddr().(*net.UDPAddr))

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

func sendSimpleReply(conn net.Conn, rep byte) error {
	p := socks5.NewReply(rep, socks5.ATYPIPv4, []byte{0, 0, 0, 0}, []byte{0, 0})
	_, err := p.WriteTo(conn)
	return err
}

func sendUDPReply(conn net.Conn, addr *net.UDPAddr) error {
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

func main() {}
