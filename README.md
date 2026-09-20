# GoodWin VPN client

Flutter VPN client: **Xray · Hysteria 2 · TrustTunnel**.

This repository is a distilled public slice of a private monorepo.
Relative paths match the monorepo (`goodwin-vpn-client/` + `goodwin-vpn-core/` + `tools/`).

## Layout

| Path | Role |
|------|------|
| `goodwin-vpn-client/` | Flutter app |
| `goodwin-vpn-core/` | Dart package + native core sources |
| `tools/` | Node build / setup scripts |
| `configs/secrets/` | Local secrets (gitignored; see README there) |

## Quick start (Windows)

```powershell
node tools/setup_refs.mjs
node tools/build_host_native.mjs
node tools/setup_wintun.mjs
node tools/build_windows_tun2socks.mjs
cd goodwin-vpn-client
flutter pub get
flutter run -d windows
```

Core tests:

```powershell
cd goodwin-vpn-core/packages/goodwin_vpn_core
dart pub get
dart test
```

Local CI parity: `node tools/ci.mjs`

`refs/` and native binaries (`jniLibs/`, `windows/libs/`, …) are **not** in git — build them locally.

## License

Proprietary / all rights reserved unless noted otherwise in-tree.
