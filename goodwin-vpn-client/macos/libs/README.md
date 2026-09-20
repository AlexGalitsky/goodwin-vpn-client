# macOS SOCKS cores

Gitignored: `libxray.dylib`, `libhysteria.dylib` (host arch, typically arm64).

Release builds exclude x86_64 (`EXCLUDED_ARCHS` in `Runner/Configs`). Universal / Intel later.

On a Mac, from repo root:

```bash
node tools/setup_refs.mjs
node tools/build_apple_native.mjs
```

Xcode copies existing dylibs next to the binary (`Contents/MacOS/`) on each Flutter build. See `docs/platforms/macos.md` and `docs/platforms/apple-onboarding.md`.
