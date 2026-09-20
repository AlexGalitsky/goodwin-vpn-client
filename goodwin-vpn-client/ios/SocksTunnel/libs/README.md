# iOS SocksTunnel libs

Built by `node tools/build_apple_native.mjs` → `libgoodwin_vpn_tun.a` (gitignored `*.a`, **iphoneos/arm64**).

Simulator links `../GoodwinVpnTunStub.c` instead (UI only; Packet Tunnel is device-only).

One Go runtime: Xray + Hysteria engines + tun2socks/gVisor for Packet Tunnel (P-I2 / P-I3).
