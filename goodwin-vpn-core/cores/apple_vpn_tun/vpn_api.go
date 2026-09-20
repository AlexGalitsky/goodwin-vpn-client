package main

/*
#include <stdint.h>
typedef void (*goodwin_vpn_out_fn)(const uint8_t* data, int len, void* ctx);
*/
import "C"

import (
	"unsafe"

	"github.com/xjasonlyu/tun2socks/v2/log"
)

//export GoodwinVpnStartCore
// Handshake + SOCKS listen only. Call before setTunnelNetworkSettings for Hy2
// so the QUIC UDP socket is bound on the physical interface.
func GoodwinVpnStartCore(coreKind *C.char, configJson *C.char, socksPort C.int) C.int {
	mu.Lock()
	defer mu.Unlock()
	kind := C.GoString(coreKind)
	cfg := C.GoString(configJson)
	port := int(socksPort)
	if port <= 0 {
		port = 10808
	}
	lastSocksP = port
	if err := startCore(kind, cfg, port); err != nil {
		log.Errorf("core start: %v", err)
		return -10
	}
	return 0
}

//export GoodwinVpnStart
// core: "xray" | "hysteria2". Starts SOCKS engine then packetFlow tun2socks → 127.0.0.1:socksPort.
func GoodwinVpnStart(
	coreKind *C.char,
	configJson *C.char,
	socksPort C.int,
	outFn C.goodwin_vpn_out_fn,
	outCtx unsafe.Pointer,
) C.int {
	mu.Lock()
	defer mu.Unlock()
	if ep != nil {
		return 0
	}
	kind := C.GoString(coreKind)
	cfg := C.GoString(configJson)
	port := int(socksPort)
	if port <= 0 {
		port = 10808
	}
	lastSocksP = port
	if err := startCore(kind, cfg, port); err != nil {
		log.Errorf("core start: %v", err)
		return -10
	}
	user, pass := socksAuthFromJSON(kind, cfg)
	if err := startProxy(port, user, pass); err != nil {
		stopCore()
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
		stopCore()
		return code
	}
	pipe = p
	return 0
}

//export GoodwinVpnRestartCore
func GoodwinVpnRestartCore(coreKind *C.char, configJson *C.char) C.int {
	mu.Lock()
	defer mu.Unlock()
	kind := C.GoString(coreKind)
	cfg := C.GoString(configJson)
	port := lastSocksP
	if port <= 0 {
		port = 10808
	}
	stopCore()
	if err := startCore(kind, cfg, port); err != nil {
		log.Errorf("core restart: %v", err)
		return -10
	}
	return 0
}

//export GoodwinVpnInput
func GoodwinVpnInput(data *C.uint8_t, length C.int) {
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
	}
}

//export GoodwinVpnStop
func GoodwinVpnStop() {
	mu.Lock()
	defer mu.Unlock()
	stopTunLocked()
	stopCore()
}

func main() {}
