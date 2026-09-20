# Goodwin VPN client

Flutter client: **Xray · Hysteria · TrustTunnel**. Sing-Box — parked.

**Docs:** [`../docs/client/`](../docs/client/)  
**Core:** [`../goodwin-vpn-core/packages/goodwin_vpn_core/`](../goodwin-vpn-core/packages/goodwin_vpn_core/)  
**Очередь:** [`../docs/client/work-plan.md`](../docs/client/work-plan.md)

```powershell
# from monorepo root
node tools/setup_refs.mjs
node tools/build_host_native.mjs
node tools/setup_wintun.mjs
node tools/build_windows_tun2socks.mjs

cd goodwin-vpn-client
flutter pub get
flutter run -d windows
```
