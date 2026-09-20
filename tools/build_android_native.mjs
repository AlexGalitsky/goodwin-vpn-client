#!/usr/bin/env node
/**
 * Build Android native libs into app/android/.../jniLibs.
 * Requires: Go, Android NDK, ndk-build. Cross-platform (Windows / macOS / Linux).
 *
 * Usage (from repo root):
 *   node tools/build_android_native.mjs
 */

import { spawnSync } from 'node:child_process';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { HEV_PIN, HEV_URL } from './hev_pin.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, '..');
const XRAY_API = 24;
const HYSTERIA_API = 26;
const ABIS = [
  { abi: 'arm64-v8a', goArch: 'arm64', clang: 'aarch64-linux-android' },
  { abi: 'armeabi-v7a', goArch: 'arm', clang: 'armv7a-linux-androideabi', goArm: '7' },
  { abi: 'x86_64', goArch: 'amd64', clang: 'x86_64-linux-android' },
];

function die(msg) {
  console.error(msg);
  process.exit(1);
}

function run(cmd, args, opts = {}) {
  const r = spawnSync(cmd, args, {
    stdio: 'inherit',
    shell: process.platform === 'win32',
    ...opts,
  });
  if (r.error) throw r.error;
  if (r.status !== 0) {
    die(`${cmd} ${args.join(' ')} failed (exit ${r.status})`);
  }
}

function which(bin) {
  const r = spawnSync(process.platform === 'win32' ? 'where' : 'which', [bin], {
    encoding: 'utf8',
    shell: process.platform === 'win32',
  });
  return r.status === 0 ? r.stdout.trim().split(/\r?\n/)[0] : null;
}

function resolveSdk() {
  return (
    process.env.ANDROID_HOME ||
    process.env.ANDROID_SDK_ROOT ||
    (process.platform === 'win32'
      ? path.join(process.env.LOCALAPPDATA || '', 'Android', 'Sdk')
      : process.platform === 'darwin'
        ? path.join(os.homedir(), 'Library', 'Android', 'sdk')
        : path.join(os.homedir(), 'Android', 'Sdk'))
  );
}

function resolveNdk(sdk) {
  if (process.env.ANDROID_NDK_HOME && fs.existsSync(process.env.ANDROID_NDK_HOME)) {
    return process.env.ANDROID_NDK_HOME;
  }
  const ndkRoot = path.join(sdk, 'ndk');
  if (!fs.existsSync(ndkRoot)) return null;
  const versions = fs
    .readdirSync(ndkRoot, { withFileTypes: true })
    .filter((d) => d.isDirectory())
    .map((d) => d.name)
    .sort()
    .reverse();
  return versions.length ? path.join(ndkRoot, versions[0]) : null;
}

function resolvePrebuilt(ndk) {
  const base = path.join(ndk, 'toolchains', 'llvm', 'prebuilt');
  const prefer =
    process.platform === 'win32'
      ? ['windows-x86_64']
      : process.platform === 'darwin'
        ? ['darwin-arm64', 'darwin-x86_64']
        : ['linux-x86_64', 'linux-arm64'];
  for (const name of prefer) {
    const p = path.join(base, name);
    if (fs.existsSync(p)) return p;
  }
  if (!fs.existsSync(base)) die(`NDK prebuilt missing under ${base}`);
  const found = fs.readdirSync(base).find((n) => fs.statSync(path.join(base, n)).isDirectory());
  if (!found) die(`No NDK host prebuilt in ${base}`);
  return path.join(base, found);
}

function clangPath(prebuiltBin, clangBase, api) {
  const stem = `${clangBase}${api}-clang`;
  const candidates =
    process.platform === 'win32' ? [`${stem}.cmd`, stem] : [stem, `${stem}.cmd`];
  for (const name of candidates) {
    const full = path.join(prebuiltBin, name);
    if (fs.existsSync(full)) return full;
  }
  die(`clang not found for ${stem} in ${prebuiltBin}`);
}

function ensureDir(dir) {
  fs.mkdirSync(dir, { recursive: true });
}

function copyFile(src, dest) {
  ensureDir(path.dirname(dest));
  fs.copyFileSync(src, dest);
}

function buildGoShared({
  name,
  srcDir,
  outName,
  jni,
  prebuiltBin,
  api,
  skipIfMissingMain,
}) {
  if (skipIfMissingMain && !fs.existsSync(path.join(srcDir, 'main.go'))) {
    console.log(`skip ${outName} (${path.relative(ROOT, srcDir)} missing)`);
    return;
  }
  for (const { abi, goArch, clang, goArm } of ABIS) {
    const outDir = path.join(srcDir, 'build', 'android', abi);
    ensureDir(outDir);
    const outSo = path.join(outDir, outName);
    const env = {
      ...process.env,
      CGO_ENABLED: '1',
      GOOS: 'android',
      GOARCH: goArch,
      CC: clangPath(prebuiltBin, clang, api),
    };
    if (goArm) {
      env.GOARM = goArm;
    } else {
      delete env.GOARM;
      env.CGO_LDFLAGS = '-Wl,-z,max-page-size=16384';
    }

    console.log(`build ${outName} ${abi}…`);
    run('go', ['build', '-ldflags=-checklinkname=0', '-buildmode=c-shared', '-o', outSo, '.'], {
      cwd: srcDir,
      env,
    });
    copyFile(outSo, path.join(jni, abi, outName));
    console.log(`ok ${outName} ${abi}`);
  }
}

function ensureHevClone(hevSrc) {
  const pinFile = path.join(hevSrc, '.git');
  if (!fs.existsSync(hevSrc) || !fs.existsSync(pinFile)) {
    if (fs.existsSync(hevSrc)) {
      fs.rmSync(hevSrc, { recursive: true, force: true });
    }
    console.log(`clone hev-socks5-tunnel @ ${HEV_PIN}…`);
    ensureDir(path.dirname(hevSrc));
    run('git', ['clone', '--recursive', '--branch', HEV_PIN, '--depth', '1', HEV_URL, hevSrc]);
    return;
  }
  const tag = spawnSync('git', ['describe', '--tags', '--exact-match'], {
    cwd: hevSrc,
    encoding: 'utf8',
    shell: process.platform === 'win32',
  });
  if ((tag.stdout || '').trim() === HEV_PIN) return;
  console.log(`checkout hev-socks5-tunnel ${HEV_PIN}…`);
  run('git', ['fetch', '--tags', '--depth', '1', 'origin', `refs/tags/${HEV_PIN}:refs/tags/${HEV_PIN}`], {
    cwd: hevSrc,
  });
  run('git', ['checkout', HEV_PIN], { cwd: hevSrc });
  run('git', ['submodule', 'update', '--init', '--recursive'], { cwd: hevSrc });
}

function linkJni(hevBuild, hevSrc) {
  ensureDir(hevBuild);
  const jniLink = path.join(hevBuild, 'jni');
  if (fs.existsSync(jniLink)) return;
  if (process.platform === 'win32') {
    // Directory junction (no admin); works when symlink privilege is missing.
    run('cmd', ['/c', `mklink /J "${jniLink}" "${hevSrc}"`]);
  } else {
    fs.symlinkSync(hevSrc, jniLink, 'dir');
  }
}

function buildHev(ndk, jni) {
  const hevSrc = path.join(ROOT, 'refs', 'hev-socks5-tunnel');
  const hevBuild = path.join(ROOT, 'refs', 'hev-android-build');
  ensureHevClone(hevSrc);
  linkJni(hevBuild, hevSrc);

  const ndkBuild =
    process.platform === 'win32'
      ? path.join(ndk, 'ndk-build.cmd')
      : path.join(ndk, 'ndk-build');
  if (!fs.existsSync(ndkBuild)) die(`ndk-build not found: ${ndkBuild}`);

  const abiList = ABIS.map((a) => a.abi).join(',');
  console.log(`ndk-build hev-socks5-tunnel @ ${HEV_PIN} (16 KB)…`);
  run(
    ndkBuild,
    [
      `APP_ABI=${abiList}`,
      'APP_CFLAGS=-O3 -DPKGNAME=website/goodwin/vpnclient -DCLSNAME=HevTunnelBridge',
      'APP_SUPPORT_FLEXIBLE_PAGE_SIZES=true',
      'APP_LDFLAGS=-Wl,-z,max-page-size=16384 -Wl,-z,common-page-size=16384',
      '-j8',
    ],
    { cwd: hevBuild },
  );

  for (const { abi } of ABIS) {
    const src = path.join(hevBuild, 'libs', abi, 'libhev-socks5-tunnel.so');
    if (!fs.existsSync(src)) die(`missing ${src}`);
    copyFile(src, path.join(jni, abi, 'libhev-socks5-tunnel.so'));
    console.log(`ok libhev-socks5-tunnel.so ${abi}`);
  }
}

function stripHostAppleCgoEnv() {
  // A Mac shell after Apple builds often has MACOSX_DEPLOYMENT_TARGET /
  // CGO_CFLAGS=-mmacosx-version-min=…; NDK clang then fails with
  // -Werror,-Wunused-command-line-argument.
  for (const key of [
    'MACOSX_DEPLOYMENT_TARGET',
    'IPHONEOS_DEPLOYMENT_TARGET',
    'CGO_CFLAGS',
    'CGO_LDFLAGS',
    'CGO_CPPFLAGS',
    'CGO_CXXFLAGS',
    'SDKROOT',
  ]) {
    delete process.env[key];
  }
}

function main() {
  if (!which('go')) die('Go not found in PATH');
  stripHostAppleCgoEnv();
  const sdk = resolveSdk();
  const ndk = resolveNdk(sdk);
  if (!ndk) die('Android NDK not found. Set ANDROID_NDK_HOME or install NDK under ANDROID_HOME.');
  const prebuilt = resolvePrebuilt(ndk);
  const prebuiltBin = path.join(prebuilt, 'bin');
  const jni = path.join(ROOT, 'goodwin-vpn-client', 'android', 'app', 'src', 'main', 'jniLibs');

  console.log(`NDK: ${ndk}`);
  console.log(`prebuilt: ${prebuilt}`);

  buildGoShared({
    name: 'xray',
    srcDir: path.join(ROOT, 'refs', 'xray-cshare'),
    outName: 'libxray.so',
    jni,
    prebuiltBin,
    api: XRAY_API,
  });

  buildGoShared({
    name: 'hysteria',
    srcDir: path.join(ROOT, 'goodwin-vpn-core', 'cores', 'hysteria'),
    outName: 'libhysteria.so',
    jni,
    prebuiltBin,
    api: HYSTERIA_API,
    skipIfMissingMain: true,
  });

  buildHev(ndk, jni);
  run('node', [path.join(ROOT, 'tools', 'check_android_jni.mjs')]);
  console.log(`Done. jniLibs -> ${jni}`);
}

main();
