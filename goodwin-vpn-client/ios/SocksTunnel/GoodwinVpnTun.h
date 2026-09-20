#ifndef GoodwinVpnTun_h
#define GoodwinVpnTun_h

#include <stdint.h>

/// Device: `libs/libgoodwin_vpn_tun.a` (Go). Simulator: `GoodwinVpnTunStub.c`.

#ifdef __cplusplus
extern "C" {
#endif

typedef void (*goodwin_vpn_out_fn)(const uint8_t* data, int len, void* ctx);

/// Handshake + SOCKS only (no tun2socks). Hy2: call before tunnel routes.
int GoodwinVpnStartCore(const char* core, const char* configJson, int socksPort);

/// core: "xray" or "hysteria2". PacketFlow outFn must be GCD-safe.
int GoodwinVpnStart(const char* core, const char* configJson, int socksPort,
                    goodwin_vpn_out_fn outFn, void* outCtx);

int GoodwinVpnRestartCore(const char* core, const char* configJson);

void GoodwinVpnInput(const uint8_t* data, int length);

void GoodwinVpnStop(void);

#ifdef __cplusplus
}
#endif

#endif /* GoodwinVpnTun_h */
