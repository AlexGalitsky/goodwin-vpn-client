// Package main: iOS Packet Tunnel — one Go runtime with SOCKS core + tun2socks.
// Build with -tags xray OR -tags hysteria (never both in one binary).
package main

/*
#include <stdint.h>
typedef void (*goodwin_vpn_out_fn)(const uint8_t* data, int len, void* ctx);

static inline void call_goodwin_vpn_out(goodwin_vpn_out_fn fn, const uint8_t* data, int len, void* ctx) {
	if (fn != NULL) {
		fn(data, len, ctx);
	}
}
*/
import "C"

import (
	"fmt"
	"io"
	"sync"
	"unsafe"

	"github.com/xjasonlyu/tun2socks/v2/core"
	"github.com/xjasonlyu/tun2socks/v2/core/device/iobased"
	"github.com/xjasonlyu/tun2socks/v2/log"
	"github.com/xjasonlyu/tun2socks/v2/proxy/socks5"
	"github.com/xjasonlyu/tun2socks/v2/tunnel"
	"gvisor.dev/gvisor/pkg/tcpip/stack"
)

const mtu = 1500

type pktPipe struct {
	inbound chan []byte
	closed  chan struct{}
	outFn   C.goodwin_vpn_out_fn
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
	cp := append([]byte(nil), b...)
	C.call_goodwin_vpn_out(p.outFn, (*C.uint8_t)(unsafe.Pointer(&cp[0])), C.int(len(cp)), p.outCtx)
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

var (
	mu         sync.Mutex
	pipe       *pktPipe
	stk        *stack.Stack
	ep         *iobased.Endpoint
	lastSocksP int
)

func startProxy(socksPort int, user, pass string) error {
	if socksPort <= 0 {
		socksPort = 10808
	}
	addr := fmt.Sprintf("127.0.0.1:%d", socksPort)
	proxy, err := socks5.New(addr, user, pass)
	if err != nil {
		return err
	}
	tunnel.T().SetProxy(proxy)
	return nil
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

func stopTunLocked() {
	if pipe != nil {
		pipe.Close()
		pipe = nil
	}
	if ep != nil {
		ep.Close()
		ep = nil
	}
	if stk != nil {
		stk.Close()
		stk = nil
	}
}
