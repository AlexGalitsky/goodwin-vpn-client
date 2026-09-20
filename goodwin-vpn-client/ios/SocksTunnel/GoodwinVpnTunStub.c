#include "GoodwinVpnTun.h"

#include <TargetConditionals.h>
#include <stdio.h>

#if TARGET_OS_SIMULATOR

/// Packet Tunnel is device-only (`iphoneos` `libgoodwin_vpn_tun.a`).
/// Simulator links this stub so UI builds (`flutter build ios --simulator`).

int GoodwinVpnStartCore(const char* core, const char* configJson, int socksPort) {
  (void)core;
  (void)configJson;
  (void)socksPort;
  fprintf(stderr, "GoodwinVpnStartCore: iOS Simulator stub (VPN is device-only)\n");
  return -1;
}

int GoodwinVpnStart(const char* core, const char* configJson, int socksPort,
                    goodwin_vpn_out_fn outFn, void* outCtx) {
  (void)core;
  (void)configJson;
  (void)socksPort;
  (void)outFn;
  (void)outCtx;
  fprintf(stderr, "GoodwinVpnStart: iOS Simulator stub (VPN is device-only)\n");
  return -1;
}

int GoodwinVpnRestartCore(const char* core, const char* configJson) {
  (void)core;
  (void)configJson;
  return -1;
}

void GoodwinVpnInput(const uint8_t* data, int length) {
  (void)data;
  (void)length;
}

void GoodwinVpnStop(void) {}

#endif /* TARGET_OS_SIMULATOR */
