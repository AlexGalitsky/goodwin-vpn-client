# Android

Release-проверенный runner: системный VPN для **Xray**, **Hysteria 2**, **TrustTunnel**.

Подробности и чеклист устройства: [`../../docs/platforms/android.md`](../../docs/platforms/android.md).

| Ядро | Путь |
|------|------|
| Xray | hev → `libxray.so` SOCKS |
| Hysteria 2 | hev → `libhysteria.so` SOCKS |
| TrustTunnel | `vpn_plugin` VpnService (`GPR_KEY` / `github-pat`), `minSdk 26` |

**Release:** R8 keep `HevTunnelBridge` (`proguard-rules.pro`). Без этого hev `JNI_OnLoad` → `JNI_ERR`.

**Сборка `.so`:** `node tools/setup_refs.mjs` затем `node tools/build_android_native.mjs` (`jniLibs/` в gitignore).
