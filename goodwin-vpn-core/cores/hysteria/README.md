# Hysteria 2 core wrapper

Go `c-shared` library backed by [apernet/hysteria](https://github.com/apernet/hysteria) core/v2.

## C ABI (same packing as xray-cshare)

```c
void* Start(char* uuid, char* jsonConfig);
void  Stop(char* uuid);
int   IsStarted(char* uuid);
void* GetHysteriaVersion(void);
void  FreePointer(void* ptr);
```

## Client JSON

From `HysteriaConfigBuilder` / `hysteria2://`:

```json
{
  "server": "host:443",
  "auth": "password",
  "tls": { "sni": "cert.name", "insecure": false },
  "socks5": { "listen": "127.0.0.1:10808" }
}
```

`sni` must match the TLS certificate (SAN/CN). Host in the URI can differ.

## Build Windows

```powershell
cd cores\hysteria
$env:CGO_ENABLED = "1"
$env:GOOS = "windows"
$env:GOARCH = "amd64"
Remove-Item Env:CC -ErrorAction SilentlyContinue
go build -buildmode=c-shared -o build\libhysteria.dll .
Copy-Item build\libhysteria.dll ..\..\app\windows\libs\libhysteria.dll -Force
```

Smoke:

```powershell
python tools\test_hysteria.py
```

## Build Android

```bash
node tools/build_android_native.mjs
```

Produces `libhysteria.so` next to `libxray.so` / hev in `jniLibs/`.

## Build macOS

```bash
node tools/build_apple_native.mjs
```

Darwin only. Copies `libhysteria.dylib` to `app/macos/libs/`. See `docs/platforms/apple-onboarding.md`.

## App path

Same as Xray: SOCKS → (Android) hev TUN. App: `HysteriaVpnCore` via `SocksSession`.

## Not yet

- `obfs` / salamander (rejected with a clear error)
- pinSHA256
