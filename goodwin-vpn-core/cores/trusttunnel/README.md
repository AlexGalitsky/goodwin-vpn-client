# TrustTunnel core

Official plugin (path dependency from `app/`):

`refs/trusttunnel-client/plugins/vpn_plugin`

Upstream:

- [TrustTunnelFlutterClient](https://github.com/TrustTunnel/TrustTunnelFlutterClient)
- Native AAR: `com.adguard.trusttunnel:trusttunnel-client-android` from GitHub Packages (`TrustTunnel/TrustTunnelClient`)

## Architecture (Android)

TrustTunnel **owns** the system VpnService (not hev + SOCKS):

```
tt://?TLV
  → ShareLinkParser → TrustTunnelProfile
  → TrustTunnelVpn → vpn_plugin Configuration (INI)
  → VpnPluginImpl.start
  → com.adguard.trusttunnel.VpnService (AAR)
  → VPS
```

Xray/Hysteria path: SOCKS + `GoodwinVpnService` + hev. Exclusive `VpnSlot` — do not start both VpnServices at once.

## Build requirements

1. Clone Flutter client into `refs/trusttunnel-client` (see getting-started).
2. Generate Pigeon bindings (gitignored as `*.g.dart` / `*.g.kt`):

```powershell
cd refs\trusttunnel-client\plugins\vpn_plugin
flutter pub get
dart run pigeon --input pigeons/platform_api.dart
```

3. GitHub Packages token with `read:packages` (+ `public_repo`):

```powershell
$env:GPR_KEY = "<token>"
# or in app/android/gradle.properties: gpr.key=<token>
```

## Local patches to `vpn_plugin`

Upstream `android/build.gradle` uses `compileSdk = 34`. Current `androidx.core` needs **35+**. `node tools/setup_refs.mjs` patches it to 36; `app/android/build.gradle.kts` also bumps `:vpn_plugin` after evaluate.

4. Run on Android (`minSdk 26`). Device and emulator: Connect `tt://` → public IP = TrustTunnel server.

```powershell
cd app
flutter run -d <device-id>
```


## Windows / desktop

**Not** Goodwin Wintun/tun2socks (P-T3). Official engine from [TrustTunnelClient](https://github.com/TrustTunnel/TrustTunnelClient).

### Foundation (now)

`vpn_plugin` links **`vpn_easy.dll`** and calls `vpn_easy_start` / `vpn_easy_stop` (state callbacks).

```powershell
node tools/build_trusttunnel_windows.mjs   # vpn_easy.dll + .lib + headers
# optional CLI still available:
node tools/setup_trusttunnel_windows.mjs
```

Bins → `app/windows/libs/trusttunnel/`; CMake/plugin bundles `vpn_easy.dll` (+ `wintun.dll`) next to the exe. Needs **admin** (same UAC as SOCKS TUN).

### In-process adapter (done for link)

1. Clone → `refs/TrustTunnelClient` (`setup_refs.mjs`) — gitignored.
2. Build → `node tools/build_trusttunnel_windows.mjs` → `vpn_easy.dll` + `vpn_easy.lib`.
3. Ship → `app/windows/libs/trusttunnel/`; `vpn_plugin` Windows CMake links `.lib`, bundles DLL.
4. ~~Replace subprocess~~ — done in local `refs/trusttunnel-client` patch.

Do **not** vendor the whole C++ tree into the Flutter app — only build artifacts + headers, like `libxray.dll`.

Full Windows plan: [`docs/platforms/windows-trusttunnel-build.md`](../../docs/platforms/windows-trusttunnel-build.md) (подробная сборка) · [`docs/platforms/windows.md`](../../docs/platforms/windows.md) (обзор).

## Deep link

Parsed in `goodwin_vpn_core` (`parseTrustTunnel`). Spec: [DEEP_LINK.md](https://github.com/TrustTunnel/TrustTunnel/blob/master/DEEP_LINK.md).
