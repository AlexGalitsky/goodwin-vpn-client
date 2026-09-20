// Package main is a c-archive bridge: NEPacketTunnel ↔ SOCKS5 (tun2socks/gVisor).
// Used only by macOS SocksTunnel Network Extension (P-M3).
package main

/*
#include <stdint.h>
typedef void (*goodwin_socks_out_fn)(const uint8_t* data, int len, void* ctx);

static inline void call_goodwin_socks_out(goodwin_socks_out_fn fn, const uint8_t* data, int len, void* ctx) {
	if (fn != NULL) {
		fn(data, len, ctx);
	}
}
*/
import "C"

import (
	"encoding/binary"
	"fmt"
	"io"
	"os"
	"sync"
	"syscall"
	"unsafe"

	"github.com/xjasonlyu/tun2socks/v2/core"
	"github.com/xjasonlyu/tun2socks/v2/core/device/iobased"
	"github.com/xjasonlyu/tun2socks/v2/log"
	"github.com/xjasonlyu/tun2socks/v2/proxy/socks5"
	"github.com/xjasonlyu/tun2socks/v2/tunnel"
	"gvisor.dev/gvisor/pkg/tcpip/stack"
)

const mtu = 1500

// pktPipe feeds NEPacketTunnelFlow packets into gVisor (offset 0 = raw IP).
type pktPipe struct {
	inbound chan []byte
	closed  chan struct{}
	outFn   C.goodwin_socks_out_fn
	outCtx  unsafe.Pointer
	closeMu sync.Mutex
	pending []byte
}

func (p *pktPipe) Read(b []byte) (int, error) {
	if len(p.pending) > 0 {
		n := copy(b, p.pending)
		p.pending = p.pending[n:]
		return n, nil
	}
	select {
	case <-p.closed:
		return 0, io.EOF
	case pkt, ok := <-p.inbound:
		if !ok {
			return 0, io.EOF
		}
		n := copy(b, pkt)
		if n < len(pkt) {
			p.pending = pkt[n:]
		}
		return n, nil
	}
}

func (p *pktPipe) Write(b []byte) (int, error) {
	select {
	case <-p.closed:
		return 0, io.ErrClosedPipe
	default:
	}
	if p.outFn == nil || len(b) == 0 {
		return len(b), nil
	}
	// Copy: Flatten buffers may be reused after Write returns; Swift also copies.
	cp := append([]byte(nil), b...)
	C.call_goodwin_socks_out(p.outFn, (*C.uint8_t)(unsafe.Pointer(&cp[0])), C.int(len(cp)), p.outCtx)
	return len(b), nil
}

func (p *pktPipe) Close() {
	p.closeMu.Lock()
	defer p.closeMu.Unlock()
	select {
	case <-p.closed:
	default:
		close(p.closed)
	}
}

// piFile wraps Darwin utun: 4-byte address-family header before each IP packet.
type piFile struct {
	f *os.File
}

func (p *piFile) Read(b []byte) (int, error) {
	buf := make([]byte, 4+len(b))
	n, err := p.f.Read(buf)
	if n <= 4 {
		if err != nil {
			return 0, err
		}
		return 0, nil
	}
	return copy(b, buf[4:n]), err
}

func (p *piFile) Write(b []byte) (int, error) {
	if len(b) == 0 {
		return 0, nil
	}
	buf := make([]byte, 4+len(b))
	family := uint32(syscall.AF_INET)
	if b[0]>>4 == 6 {
		family = uint32(syscall.AF_INET6)
	}
	binary.BigEndian.PutUint32(buf[0:4], family)
	copy(buf[4:], b)
	wn, err := p.f.Write(buf)
	if wn > 4 {
		return wn - 4, err
	}
	if err != nil {
		return 0, err
	}
	return 0, nil
}

func (p *piFile) Close() error { return p.f.Close() }

var (
	mu     sync.Mutex
	pipe   *pktPipe
	stk    *stack.Stack
	ep     *iobased.Endpoint
	piTun  *piFile
)

func startProxy(socksHost *C.char, socksPort C.int) (string, error) {
	host := C.GoString(socksHost)
	if host == "" {
		host = "127.0.0.1"
	}
	port := int(socksPort)
	if port <= 0 {
		port = 10808
	}
	addr := fmt.Sprintf("%s:%d", host, port)
	proxy, err := socks5.New(addr, "", "")
	if err != nil {
		return "", err
	}
	tunnel.T().SetProxy(proxy)
	return addr, nil
}

func wireStack(rw io.ReadWriter) C.int {
	endpoint, err := iobased.New(rw, mtu, 0)
	if err != nil {
		log.Errorf("iobased: %v", err)
		return -4
	}
	s, err := core.CreateStack(&core.Config{
		LinkEndpoint:     endpoint,
		TransportHandler: tunnel.T(),
	})
	if err != nil {
		endpoint.Close()
		log.Errorf("stack: %v", err)
		return -5
	}
	ep = endpoint
	stk = s
	return 0
}

//export GoodwinSocksTunStart
// PacketFlow mode: Swift feeds packets via GoodwinSocksTunInput; outFn must
// dispatch writePackets onto a GCD queue (never call NE APIs directly on a Go thread).
func GoodwinSocksTunStart(socksHost *C.char, socksPort C.int, outFn C.goodwin_socks_out_fn, outCtx unsafe.Pointer) C.int {
	mu.Lock()
	defer mu.Unlock()
	if ep != nil {
		return 0
	}
	if _, err := startProxy(socksHost, socksPort); err != nil {
		log.Errorf("socks5: %v", err)
		return -2
	}
	p := &pktPipe{
		inbound: make(chan []byte, 1024),
		closed:  make(chan struct{}),
		outFn:   outFn,
		outCtx:  outCtx,
	}
	if code := wireStack(p); code != 0 {
		return code
	}
	pipe = p
	return 0
}

//export GoodwinSocksTunStartFd
// Optional: dup'd NE utun FD (when socket.fileDescriptor is available).
func GoodwinSocksTunStartFd(tunFd C.int, socksHost *C.char, socksPort C.int) C.int {
	mu.Lock()
	defer mu.Unlock()
	if ep != nil {
		return 0
	}
	fd := int(tunFd)
	if fd < 0 {
		return -1
	}
	if _, err := startProxy(socksHost, socksPort); err != nil {
		log.Errorf("socks5: %v", err)
		return -2
	}
	dupFd, err := syscall.Dup(fd)
	if err != nil {
		log.Errorf("dup tun fd: %v", err)
		return -3
	}
	wrapped := &piFile{f: os.NewFile(uintptr(dupFd), "utun-ne")}
	if code := wireStack(wrapped); code != 0 {
		_ = wrapped.Close()
		return code
	}
	piTun = wrapped
	return 0
}

//export GoodwinSocksTunInput
func GoodwinSocksTunInput(data *C.uint8_t, length C.int) {
	if data == nil || length <= 0 {
		return
	}
	mu.Lock()
	p := pipe
	mu.Unlock()
	if p == nil {
		return
	}
	buf := C.GoBytes(unsafe.Pointer(data), length)
	select {
	case <-p.closed:
	case p.inbound <- buf:
	default:
		// Drop only under extreme congestion.
	}
}

//export GoodwinSocksTunStop
func GoodwinSocksTunStop() {
	mu.Lock()
	defer mu.Unlock()
	if ep == nil {
		return
	}
	if pipe != nil {
		pipe.Close()
		pipe = nil
	}
	ep.Close()
	ep = nil
	if stk != nil {
		stk.Close()
		stk = nil
	}
	if piTun != nil {
		_ = piTun.Close()
		piTun = nil
	}
}

func main() {}
