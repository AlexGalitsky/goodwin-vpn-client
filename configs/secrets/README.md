# Local secrets (not in git)

Put working connection strings here. This directory is gitignored except this README and `.gitkeep`.

| File | Protocol |
|------|----------|
| `vless.url` | Xray VLESS (one line) |
| `trusttunnel.url` | TrustTunnel `tt://` (one line) |
| `hysteria2.url` | Hysteria 2 (one line) |

Never commit `*.url`, `github-pat`, `.env`, or the Android upload keystore.

Android release signing:

```bash
node tools/setup_android_release_keystore.mjs
```

Writes `configs/secrets/android-release.jks` and `goodwin-vpn-client/android/key.properties` (both gitignored).
