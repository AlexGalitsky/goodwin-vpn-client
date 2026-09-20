# goodwin-vpn-core

Shared VPN engine layer for Goodwin clients.

| Path | Role |
|------|------|
| [`packages/goodwin_vpn_core/`](./packages/goodwin_vpn_core/) | Dart: share-link parsers, profile models, Xray/Hy2 JSON, FFI wrappers |
| [`cores/`](./cores/) | Go/native sources (Hysteria, Apple TUN helpers, TrustTunnel glue, …) |

Built artifacts land under `goodwin-vpn-client/` via `node tools/build_*.mjs` (repo root).

```powershell
cd packages/goodwin_vpn_core
dart pub get
dart test
```
