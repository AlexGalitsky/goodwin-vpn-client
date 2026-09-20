# Smoke / native tools

Scripts are **Node.js** (`.mjs`). From repo root:

| Script | Purpose |
|--------|---------|
| `setup_refs.mjs` | Clone gitignored `refs/` (xray-cshare, hev pin, TrustTunnel, …) |
| `build_android_native.mjs` | `libxray.so`, `libhysteria.so`, hev → `jniLibs/` + 16 KB ELF check |
| `check_android_jni.mjs` | Fail if `.so` missing or 64-bit PT_LOAD < 16 KB |
| `check_android_store.mjs` | hev pin, 16 KB flags, no `SYSTEM_EXEMPTED` |
| `build_android_release.mjs` | Release APK / AAB (`goodwin-vpn-client/`) — native + keystore + Flutter |
| `build_ios_release.mjs` | Release IPA / archive (`goodwin-vpn-client/`) — apple native + pods + Flutter |
| `build_linux_native.mjs` | Linux: `libxray.so` / `libhysteria.so` → `goodwin-vpn-client/linux/libs/` (через WSL с Windows) |
| `pack_linux_vm.mjs` | Zip исходников + `.so` для Linux VM (TUN там) |
| `build_apple_native.mjs` | macOS: `libxray.dylib` / `libhysteria.dylib` (на Windows — только инструкция) |
| `setup_wintun.mjs` | Windows: `wintun.dll` for SOCKS TUN (tun2socks) |
| `setup_trusttunnel_windows.mjs` | Windows: TrustTunnel CLI (P-T1 foundation) |
| `build_trusttunnel_windows.mjs` | Windows: сборка `vpn_easy.dll` + headers из `refs/TrustTunnelClient` (VS CMake/Ninja; без MinGW cmake в PATH) |
| `ci.mjs` | Локальный прогон CI: analyze + test (core + app) |
| `distill_client.mjs` | Публичный срез: `goodwin-vpn-client` + `goodwin-vpn-core` + `tools` (без rewrite path’ов) |
| `vless_to_xray_json.py` | Legacy: `vless.url` → `xray-test.json` |
| `test_xray.py` / `test_hysteria.py` | Legacy Windows DLL smoke |
| `xray_cli/` | Dart FFI + `goodwin_vpn_core` |

```bash
node tools/setup_refs.mjs
node tools/build_android_native.mjs
# локальный CI:
node tools/ci.mjs
# store release:
node tools/build_android_release.mjs          # apk + aab
node tools/build_ios_release.mjs              # ipa (macOS + Distribution)

cd goodwin-vpn-core/packages/goodwin_vpn_core && dart test
cd goodwin-vpn-client && flutter test

# публичный срез (в .cache/distill/…, без push):
node tools/distill_client.mjs --clean
```

`jniLibs/` and `refs/` are **gitignored** — after a fresh clone/pull you must run setup + Android native build again on that machine.
