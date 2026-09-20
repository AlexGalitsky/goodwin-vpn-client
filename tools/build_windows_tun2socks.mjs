#!/usr/bin/env node
/**
 * Build tun2socks.exe (Wintun → SOCKS) for Windows amd64.
 *
 * Requires Go. Output: app/windows/libs/tun2socks.exe
 *
 * Usage (from repo root):
 *   node tools/build_windows_tun2socks.mjs
 */

import { spawnSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const OUT = path.join(ROOT, 'goodwin-vpn-client', 'windows', 'libs', 'tun2socks.exe');

function die(msg) {
  console.error(msg);
  process.exit(1);
}

function ensureDir(dir) {
  fs.mkdirSync(dir, { recursive: true });
}

function run(cmd, args, opts = {}) {
  // No shell: on Windows, shell splits `-ldflags=-s -w` so Go sees bare `-w`.
  const r = spawnSync(cmd, args, {
    stdio: 'inherit',
    ...opts,
  });
  if (r.error) throw r.error;
  if (r.status !== 0) die(`${cmd} failed (exit ${r.status})`);
}

if (process.platform !== 'win32') {
  console.log('tun2socks.exe is only built on Windows hosts.');
  process.exit(0);
}

ensureDir(path.dirname(OUT));
console.log('build tun2socks.exe…');
// `go install path@version` (not `go build`) — module-aware mode.
run(
  'go',
  ['install', '-trimpath', '-ldflags', '-s -w', 'github.com/xjasonlyu/tun2socks/v2@latest'],
  {
    env: {
      ...process.env,
      CGO_ENABLED: '0',
      GOOS: 'windows',
      GOARCH: 'amd64',
      GOBIN: path.dirname(OUT),
    },
  },
);
if (!fs.existsSync(OUT)) {
  die(`expected ${OUT} after go install`);
}
console.log(`ok ${OUT}`);
