#!/usr/bin/env node
/**
 * Build host (desktop) c-shared libs for the current OS.
 * Windows: libxray.dll + libhysteria.dll → app/windows/libs/
 * macOS/Linux: prints a note — desktop SOCKS runner is Windows-first for now.
 *
 * Usage (from repo root):
 *   node tools/build_host_native.mjs
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
  const r = spawnSync(cmd, args, {
    stdio: 'inherit',
    shell: process.platform === 'win32',
    ...opts,
  });
  if (r.error) throw r.error;
  if (r.status !== 0) die(`${cmd} failed (exit ${r.status})`);
}

function ensureDir(dir) {
  fs.mkdirSync(dir, { recursive: true });
}

function buildWindows() {
  const xraySrc = path.join(ROOT, 'refs', 'xray-cshare');
  if (!fs.existsSync(path.join(xraySrc, 'main.go')) && !fs.existsSync(xraySrc)) {
    die('refs/xray-cshare missing — run: node tools/setup_refs.mjs');
  }
  const xrayOut = path.join(xraySrc, 'build', 'libxray.dll');
  ensureDir(path.dirname(xrayOut));
  console.log('build libxray.dll…');
  run('go', ['build', '-buildmode=c-shared', '-o', xrayOut, '.'], {
    cwd: xraySrc,
    env: { ...process.env, CGO_ENABLED: '1', GOOS: 'windows', GOARCH: 'amd64' },
  });
  const winLibs = path.join(ROOT, 'goodwin-vpn-client', 'windows', 'libs');
  ensureDir(winLibs);
  fs.copyFileSync(xrayOut, path.join(winLibs, 'libxray.dll'));
  console.log('ok libxray.dll');

  const hySrc = path.join(ROOT, 'goodwin-vpn-core', 'cores', 'hysteria');
  if (!fs.existsSync(path.join(hySrc, 'main.go'))) {
    console.log('skip libhysteria.dll (cores/hysteria missing)');
    return;
  }
  const hyOut = path.join(hySrc, 'build', 'libhysteria.dll');
  ensureDir(path.dirname(hyOut));
  console.log('build libhysteria.dll…');
  run('go', ['build', '-buildmode=c-shared', '-o', hyOut, '.'], {
    cwd: hySrc,
    env: { ...process.env, CGO_ENABLED: '1', GOOS: 'windows', GOARCH: 'amd64' },
  });
  fs.copyFileSync(hyOut, path.join(winLibs, 'libhysteria.dll'));
  console.log('ok libhysteria.dll');
}

if (process.platform === 'win32') {
  buildWindows();
  console.log('Done. app/windows/libs ready');
  console.log('Linux .so via WSL: node tools/build_linux_native.mjs');
} else if (process.platform === 'linux') {
  console.log('Use: node tools/build_linux_native.mjs');
} else {
  console.log(
    `Host native for ${process.platform}: desktop SOCKS is Windows-first.\n` +
      'Linux: node tools/build_linux_native.mjs\n' +
      'Android: node tools/build_android_native.mjs',
  );
}
