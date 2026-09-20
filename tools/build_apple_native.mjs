#!/usr/bin/env node
/**
 * macOS desktop natives:
 *   - libxray.dylib + libhysteria.dylib → app/macos/libs/ (P-M2 SOCKS FFI)
 *   - libgoodwin_socks_tun.a → app/macos/SocksTunnel/libs/ (P-M3 Packet Tunnel)
 *   - libgoodwin_vpn_tun.a → app/ios/SocksTunnel/libs/ (iphoneos/arm64; simulator uses GoodwinVpnTunStub.c)
 *
 * Must run on macOS (Xcode CLT + Go). On Windows this script only prints the
 * Mac checklist — Apple binaries cannot be built here.
 *
 * Usage (on a Mac, from repo root):
 *   node tools/setup_refs.mjs
 *   node tools/build_apple_native.mjs
 */

import { spawnSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');

function die(msg) {
  console.error(msg);
  process.exit(1);
}

function run(cmd, args, opts = {}) {
  const r = spawnSync(cmd, args, { stdio: 'inherit', ...opts });
  if (r.error) throw r.error;
  if (r.status !== 0) die(`${cmd} failed (exit ${r.status})`);
}

/** vpn_plugin path dep needs Pigeon outputs (not committed in upstream clone). */
function ensureVpnPluginPigeon() {
  const plugin = path.join(ROOT, 'refs', 'trusttunnel-client', 'plugins', 'vpn_plugin');
  const dartOut = path.join(plugin, 'lib', 'platform_api.g.dart');
  const macosSwift = path.join(plugin, 'macos', 'Classes', 'PlatformApi.g.swift');
  const iosSwift = path.join(plugin, 'ios', 'Classes', 'PlatformApi.g.swift');
  if (fs.existsSync(dartOut) && fs.existsSync(macosSwift) && fs.existsSync(iosSwift)) return;
  if (!fs.existsSync(path.join(plugin, 'pubspec.yaml'))) {
    die('refs/trusttunnel-client missing — run: node tools/setup_refs.mjs');
  }
  console.log('generate vpn_plugin pigeon…');
  run('flutter', ['pub', 'get'], { cwd: plugin });
  run('dart', ['run', 'pigeon', '--input', 'pigeons/platform_api.dart'], { cwd: plugin });
}

/**
 * Official vpn_plugin hardcodes AdGuard extension / App Group IDs.
 * Patch macOS + iOS (refs/ is gitignored — re-run after setup_refs).
 */
function patchVpnPluginAppleIds() {
  const fromExt = 'com.adguard.TrustTunnel.Extension';
  const fromGroup = 'group.com.adguard.TrustTunnel';
  const toExt = 'website.goodwin.goodwinVpnClient.tunnel';
  const toGroup = 'group.website.goodwin.goodwinVpnClient';
  for (const plat of ['macos', 'ios']) {
    const file = path.join(
      ROOT,
      'refs',
      'trusttunnel-client',
      'plugins',
      'vpn_plugin',
      plat,
      'Classes',
      'VpnPlugin.swift',
    );
    if (!fs.existsSync(file)) {
      die(`vpn_plugin ${plat} missing — run: node tools/setup_refs.mjs`);
    }
    let src = fs.readFileSync(file, 'utf8');
    let changed = false;
    if (!src.includes(toExt) || !src.includes(toGroup)) {
      if (!src.includes(fromExt) || !src.includes(fromGroup)) {
        die(`vpn_plugin ${plat} IDs unexpected — expected ${fromExt} / ${fromGroup}`);
      }
      src = src.replaceAll(fromExt, toExt).replaceAll(fromGroup, toGroup);
      changed = true;
      console.log(`patched vpn_plugin ${plat} → ${toExt} / ${toGroup}`);
    }
    const named = src.replace(
      /localizedDescription\s*=\s*"[^"]*"/g,
      'localizedDescription = "GoodWin VPN"',
    );
    if (named !== src) {
      src = named;
      changed = true;
      console.log(`patched vpn_plugin ${plat} Settings VPN name → GoodWin VPN`);
    }
    if (changed) fs.writeFileSync(file, src);
    else console.log(`vpn_plugin ${plat} IDs already patched`);
  }
}

function setInstallName(dylibPath) {
  const id = `@executable_path/${path.basename(dylibPath)}`;
  run('install_name_tool', ['-id', id, dylibPath]);
}

function resolveCodesignIdentity() {
  if (process.env.APPLE_CODESIGN_IDENTITY) return process.env.APPLE_CODESIGN_IDENTITY;
  const listed = spawnSync('security', ['find-identity', '-v', '-p', 'codesigning'], {
    encoding: 'utf8',
  });
  const hashes = [
    ...(listed.stdout || '').matchAll(/^\s*\d+\)\s+([A-F0-9]{40})\s+"/gm),
  ].map((m) => m[1]);
  if (hashes.length === 0) {
    die('no codesigning identity — set APPLE_CODESIGN_IDENTITY');
  }
  return hashes[0];
}

/** Sign Go c-shared for Hardened Runtime + Network Extension (no disable-library-validation). */
function codesignDylib(dylibPath) {
  const identity = resolveCodesignIdentity();
  console.log(`codesign ${path.basename(dylibPath)} (${identity})…`);
  run('codesign', [
    '--force',
    '--sign',
    identity,
    '--timestamp=none',
    '--options',
    'runtime',
    dylibPath,
  ]);
}

if (process.platform !== 'darwin') {
  console.log(`build_apple_native: host is ${process.platform}, not darwin.
Apple .dylib / iOS cannot be compiled on Windows.

On the Mac (after git clone):
  node tools/setup_refs.mjs
  node tools/build_apple_native.mjs
  cd app && flutter run -d macos

Playbook: docs/platforms/apple-onboarding.md
`);
  process.exit(0);
}

const arch = process.arch === 'arm64' ? 'arm64' : 'amd64';
const env = {
  ...process.env,
  CGO_ENABLED: '1',
  GOOS: 'darwin',
  GOARCH: arch,
};
const outDir = path.join(ROOT, 'goodwin-vpn-client', 'macos', 'libs');
fs.mkdirSync(outDir, { recursive: true });

ensureVpnPluginPigeon();
patchVpnPluginAppleIds();

const xraySrc = path.join(ROOT, 'refs', 'xray-cshare');
if (!fs.existsSync(path.join(xraySrc, 'go.mod'))) {
  die('refs/xray-cshare missing — run: node tools/setup_refs.mjs');
}
const xrayOut = path.join(xraySrc, 'build', 'libxray.dylib');
fs.mkdirSync(path.dirname(xrayOut), { recursive: true });
console.log(`build libxray.dylib (${arch})…`);
run('go', ['build', '-ldflags=-checklinkname=0', '-buildmode=c-shared', '-o', xrayOut, '.'], {
  cwd: xraySrc,
  env,
});
const xrayDest = path.join(outDir, 'libxray.dylib');
fs.copyFileSync(xrayOut, xrayDest);
setInstallName(xrayDest);
codesignDylib(xrayDest);
console.log('ok libxray.dylib');

const hySrc = path.join(ROOT, 'goodwin-vpn-core', 'cores', 'hysteria');
if (fs.existsSync(path.join(hySrc, 'main.go'))) {
  const hyOut = path.join(hySrc, 'build', 'libhysteria.dylib');
  fs.mkdirSync(path.dirname(hyOut), { recursive: true });
  console.log('build libhysteria.dylib…');
  run('go', ['build', '-ldflags=-checklinkname=0', '-buildmode=c-shared', '-o', hyOut, '.'], {
    cwd: hySrc,
    env,
  });
  const hyDest = path.join(outDir, 'libhysteria.dylib');
  fs.copyFileSync(hyOut, hyDest);
  setInstallName(hyDest);
  codesignDylib(hyDest);
  console.log('ok libhysteria.dylib');
}

const socksTunSrc = path.join(ROOT, 'goodwin-vpn-core', 'cores', 'apple_socks_tun');
if (fs.existsSync(path.join(socksTunSrc, 'main.go'))) {
  const socksOutDir = path.join(ROOT, 'goodwin-vpn-client', 'macos', 'SocksTunnel', 'libs');
  fs.mkdirSync(socksOutDir, { recursive: true });
  const socksOut = path.join(socksOutDir, 'libgoodwin_socks_tun.a');
  console.log(`build libgoodwin_socks_tun.a (${arch})…`);
  run(
    'go',
    ['build', '-ldflags=-checklinkname=0', '-buildmode=c-archive', '-o', socksOut, '.'],
    {
      cwd: socksTunSrc,
      env: {
        ...env,
        // Match SocksTunnel MACOSX_DEPLOYMENT_TARGET (Go runtime stamps 13.0).
        MACOSX_DEPLOYMENT_TARGET: '13.0',
        CGO_CFLAGS: '-mmacosx-version-min=13.0',
        CGO_LDFLAGS: '-mmacosx-version-min=13.0',
      },
    },
  );
  // Prefer hand-written GoodwinSocksTun.h in SocksTunnel/; drop cgo-generated header next to .a.
  const generatedHdr = path.join(socksOutDir, 'libgoodwin_socks_tun.h');
  if (fs.existsSync(generatedHdr)) fs.unlinkSync(generatedHdr);
  console.log('ok libgoodwin_socks_tun.a');
}

// iOS SocksTunnel: one Go runtime (Xray + Hy2 engines + tun2socks) as c-archive.
const vpnTunSrc = path.join(ROOT, 'goodwin-vpn-core', 'cores', 'apple_vpn_tun');
if (fs.existsSync(path.join(vpnTunSrc, 'vpn_api.go'))) {
  const iosLibs = path.join(ROOT, 'goodwin-vpn-client', 'ios', 'SocksTunnel', 'libs');
  fs.mkdirSync(iosLibs, { recursive: true });
  const vpnOut = path.join(iosLibs, 'libgoodwin_vpn_tun.a');
  const sdk = spawnSync('xcrun', ['--sdk', 'iphoneos', '--show-sdk-path'], {
    encoding: 'utf8',
  });
  if (sdk.status !== 0) die('xcrun iphoneos SDK failed');
  const sdkPath = sdk.stdout.trim();
  const clang = spawnSync('xcrun', ['--sdk', 'iphoneos', '--find', 'clang'], {
    encoding: 'utf8',
  });
  if (clang.status !== 0) die('xcrun clang failed');
  const cc = clang.stdout.trim();
  console.log('go mod tidy apple_vpn_tun…');
  run('go', ['mod', 'tidy'], { cwd: vpnTunSrc });
  console.log('build libgoodwin_vpn_tun.a (ios/arm64)…');
  run(
    'go',
    ['build', '-ldflags=-checklinkname=0', '-buildmode=c-archive', '-o', vpnOut, '.'],
    {
      cwd: vpnTunSrc,
      env: {
        ...process.env,
        CGO_ENABLED: '1',
        GOOS: 'ios',
        GOARCH: 'arm64',
        CC: cc,
        CGO_CFLAGS: `-isysroot ${sdkPath} -miphoneos-version-min=15.0 -arch arm64`,
        CGO_LDFLAGS: `-isysroot ${sdkPath} -miphoneos-version-min=15.0 -arch arm64`,
      },
    },
  );
  const genVpnHdr = path.join(iosLibs, 'libgoodwin_vpn_tun.h');
  if (fs.existsSync(genVpnHdr)) fs.unlinkSync(genVpnHdr);
  console.log('ok libgoodwin_vpn_tun.a');
}

console.log(`Done. ${outDir}`);
console.log(
  'Next: cd app && flutter run -d macos|iphone  (SOCKS / TT need Extension signing)',
);
