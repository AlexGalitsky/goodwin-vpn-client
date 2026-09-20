#!/usr/bin/env node
/**
 * Linux desktop natives: libxray.so + libhysteria.so → app/linux/libs/
 *
 * On Windows this runs the Go/CGO build inside WSL2 (needs gcc).
 * SOCKS smoke (optional): --smoke  (Dart FFI + curl --socks5 inside WSL)
 *
 * Usage (from repo root):
 *   node tools/setup_refs.mjs
 *   node tools/build_linux_native.mjs
 *   node tools/build_linux_native.mjs --smoke
 *
 * TUN is not tested here — pack a zip for a Linux VM:
 *   node tools/pack_linux_vm.mjs
 */

import { spawnSync } from 'node:child_process';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const GO_VERSION = '1.27.0';
const DART_VERSION = '3.12.2';
const WANT_SMOKE = process.argv.includes('--smoke');

function die(msg) {
  console.error(msg);
  process.exit(1);
}

function run(cmd, args, opts = {}) {
  const r = spawnSync(cmd, args, { stdio: 'inherit', ...opts });
  if (r.error) throw r.error;
  if (r.status !== 0) die(`${cmd} failed (exit ${r.status})`);
}

function toWslPath(winPath) {
  const abs = path.resolve(winPath);
  const m = abs.match(/^([A-Za-z]):[\\/](.*)$/);
  if (!m) return abs.replace(/\\/g, '/');
  return `/mnt/${m[1].toLowerCase()}/${m[2].replace(/\\/g, '/')}`;
}

function download(url, dest) {
  fs.mkdirSync(path.dirname(dest), { recursive: true });
  if (fs.existsSync(dest) && fs.statSync(dest).size > 1000) {
    console.log(`cache hit ${dest}`);
    return;
  }
  console.log(`download ${url}`);
  const tmp = `${dest}.part`;
  run('curl.exe', ['-fsSL', '-o', tmp, url]);
  fs.renameSync(tmp, dest);
}

function wslAvailable() {
  const r = spawnSync('wsl.exe', ['-e', 'true'], { stdio: 'ignore' });
  return r.status === 0;
}

function writeUnix(file, body) {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  fs.writeFileSync(file, body.replace(/\r\n/g, '\n'), 'utf8');
}

function buildInsideLinux({ rootPosix, goTarballPosix, dartZipPosix }) {
  const script = path.join(ROOT, '.cache', 'wsl_linux_build.sh');
  writeUnix(
    script,
    `#!/usr/bin/env bash
set -euo pipefail
ROOT="${rootPosix}"
export GOPATH="\$HOME/go"
export GOCACHE="\$HOME/.cache/go-build"
export GOROOT="\$HOME/.local/go"
export PATH="\$GOROOT/bin:/usr/local/bin:/usr/bin:/bin"
export CGO_ENABLED=1
export GOOS=linux
export GOARCH=amd64
export GOTOOLCHAIN=local

if ! command -v gcc >/dev/null; then
  echo "gcc missing in WSL. sudo apt install build-essential"
  exit 1
fi

if ! command -v go >/dev/null || ! go version | grep -q 'go${GO_VERSION}'; then
  echo "install Go ${GO_VERSION} → \$GOROOT"
  mkdir -p "\$HOME/.local"
  rm -rf "\$GOROOT"
  tar -C "\$HOME/.local" -xzf "${goTarballPosix}"
fi
go version

XRAY="\$ROOT/refs/xray-cshare"
if [ ! -f "\$XRAY/go.mod" ]; then
  echo "missing refs/xray-cshare — run: node tools/setup_refs.mjs"
  exit 1
fi

mkdir -p "\$XRAY/build" "\$ROOT/goodwin-vpn-client/linux/libs"
echo "build libxray.so…"
( cd "\$XRAY" && go build -ldflags="-checklinkname=0" -buildmode=c-shared -o build/libxray.so . )
cp -f "\$XRAY/build/libxray.so" "\$ROOT/goodwin-vpn-client/linux/libs/libxray.so"
echo "ok libxray.so"

HY="\$ROOT/goodwin-vpn-core/cores/hysteria"
if [ -f "\$HY/main.go" ]; then
  mkdir -p "\$HY/build"
  echo "build libhysteria.so…"
  ( cd "\$HY" && go build -ldflags="-checklinkname=0" -buildmode=c-shared -o build/libhysteria.so . )
  cp -f "\$HY/build/libhysteria.so" "\$ROOT/goodwin-vpn-client/linux/libs/libhysteria.so"
  echo "ok libhysteria.so"
else
  echo "skip libhysteria.so"
fi

ls -lh "\$ROOT/goodwin-vpn-client/linux/libs"
`,
  );
  run('wsl.exe', ['-e', 'bash', toWslPath(script)]);
}

function smokeInsideLinux({ rootPosix, dartZipPosix }) {
  const script = path.join(ROOT, '.cache', 'wsl_linux_smoke.sh');
  writeUnix(
    script,
    `#!/usr/bin/env bash
set -euo pipefail
ROOT="${rootPosix}"
DART_ROOT="\$HOME/.local/dart-sdk"
export PATH="\$DART_ROOT/bin:/usr/local/bin:/usr/bin:/bin"
export GOODWIN_LIBXRAY="\$ROOT/goodwin-vpn-client/linux/libs/libxray.so"
export PUB_CACHE="\$HOME/.pub-cache"

if [ ! -x "\$GOODWIN_LIBXRAY" ] && [ ! -f "\$GOODWIN_LIBXRAY" ]; then
  echo "missing \$GOODWIN_LIBXRAY — build first"
  exit 1
fi

if ! command -v dart >/dev/null; then
  echo "install Dart ${DART_VERSION} → \$DART_ROOT"
  mkdir -p "\$HOME/.local" "\$HOME/.cache"
  rm -rf "\$DART_ROOT"
  python3 -c "import zipfile, shutil, os; z=zipfile.ZipFile(r'''${dartZipPosix}'''); dest=os.path.expanduser('~/.cache/dart-sdk-unpack'); shutil.rmtree(dest, ignore_errors=True); os.makedirs(dest, exist_ok=True); z.extractall(dest); shutil.rmtree(os.path.expanduser('~/.local/dart-sdk'), ignore_errors=True); shutil.move(os.path.join(dest,'dart-sdk'), os.path.expanduser('~/.local/dart-sdk'))"
fi
chmod +x "\$DART_ROOT/bin/dart" "\$DART_ROOT/bin/"* 2>/dev/null || true
dart --version

cd "\$ROOT/tools/xray_cli"
dart pub get
dart run
`,
  );
  run('wsl.exe', ['-e', 'bash', toWslPath(script)]);
}

function nativeLinuxBuild() {
  const env = {
    ...process.env,
    CGO_ENABLED: '1',
    GOOS: 'linux',
    GOARCH: 'amd64',
  };
  const xraySrc = path.join(ROOT, 'refs', 'xray-cshare');
  if (!fs.existsSync(path.join(xraySrc, 'go.mod'))) {
    die('refs/xray-cshare missing — run: node tools/setup_refs.mjs');
  }
  const outDir = path.join(ROOT, 'goodwin-vpn-client', 'linux', 'libs');
  fs.mkdirSync(outDir, { recursive: true });
  const xrayOut = path.join(xraySrc, 'build', 'libxray.so');
  fs.mkdirSync(path.dirname(xrayOut), { recursive: true });
  console.log('build libxray.so…');
  run('go', ['build', '-ldflags=-checklinkname=0', '-buildmode=c-shared', '-o', xrayOut, '.'], {
    cwd: xraySrc,
    env,
  });
  fs.copyFileSync(xrayOut, path.join(outDir, 'libxray.so'));
  const hySrc = path.join(ROOT, 'goodwin-vpn-core', 'cores', 'hysteria');
  if (fs.existsSync(path.join(hySrc, 'main.go'))) {
    const hyOut = path.join(hySrc, 'build', 'libhysteria.so');
    fs.mkdirSync(path.dirname(hyOut), { recursive: true });
    console.log('build libhysteria.so…');
    run('go', ['build', '-ldflags=-checklinkname=0', '-buildmode=c-shared', '-o', hyOut, '.'], {
      cwd: hySrc,
      env,
    });
    fs.copyFileSync(hyOut, path.join(outDir, 'libhysteria.so'));
  }
}

const goTar = path.join(ROOT, '.cache', `go${GO_VERSION}.linux-amd64.tar.gz`);
const dartZip = path.join(ROOT, '.cache', `dartsdk-linux-x64-${DART_VERSION}.zip`);

if (process.platform === 'linux') {
  nativeLinuxBuild();
} else if (process.platform === 'win32') {
  if (!wslAvailable()) {
    die('WSL2 not available. Install WSL or build on a Linux VM: node tools/build_linux_native.mjs');
  }
  download(
    `https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz`,
    goTar,
  );
  buildInsideLinux({
    rootPosix: toWslPath(ROOT),
    goTarballPosix: toWslPath(goTar),
    dartZipPosix: toWslPath(dartZip),
  });
  if (WANT_SMOKE) {
    download(
      `https://storage.googleapis.com/dart-archive/channels/stable/release/${DART_VERSION}/sdk/dartsdk-linux-x64-release.zip`,
      dartZip,
    );
    smokeInsideLinux({
      rootPosix: toWslPath(ROOT),
      dartZipPosix: toWslPath(dartZip),
    });
  }
} else {
  die(`build_linux_native: unsupported host ${process.platform}`);
}

console.log('Done. app/linux/libs/');
if (!WANT_SMOKE && process.platform === 'win32') {
  console.log('SOCKS smoke in WSL:  node tools/build_linux_native.mjs --smoke');
  console.log('VM zip (TUN later):  node tools/pack_linux_vm.mjs');
}
