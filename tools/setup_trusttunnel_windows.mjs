#!/usr/bin/env node
/**
 * Download TrustTunnel CLI (Windows x64) into app/windows/libs/trusttunnel/.
 *
 * Used by vpn_plugin on Windows (P-T1) — real system TUN via trusttunnel_client.exe.
 *
 * Usage (from repo root):
 *   node tools/setup_trusttunnel_windows.mjs
 */

import { spawnSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const OUT_DIR = path.join(ROOT, 'goodwin-vpn-client', 'windows', 'libs', 'trusttunnel');
const VERSION = 'v1.0.49';
const ZIP_NAME = `trusttunnel_client-${VERSION}-windows-x86_64.zip`;
const ZIP_URL = `https://github.com/TrustTunnel/TrustTunnelClient/releases/download/${VERSION}/${ZIP_NAME}`;
const CACHE = path.join(ROOT, '.cache', ZIP_NAME);

function die(msg) {
  console.error(msg);
  process.exit(1);
}

function ensureDir(dir) {
  fs.mkdirSync(dir, { recursive: true });
}

function download(url, dest) {
  ensureDir(path.dirname(dest));
  if (fs.existsSync(dest)) {
    console.log(`cache hit ${dest}`);
    return;
  }
  console.log(`download ${url}…`);
  const r = spawnSync(
    'curl',
    ['-fsSL', '-o', dest, url],
    { stdio: 'inherit', shell: process.platform === 'win32' },
  );
  if (r.status !== 0) die('curl download failed');
}

function extractZip(zipPath) {
  const tmp = path.join(ROOT, '.cache', 'trusttunnel-extract');
  fs.rmSync(tmp, { recursive: true, force: true });
  ensureDir(tmp);
  if (process.platform === 'win32') {
    const ps = [
      'Expand-Archive',
      `-Path '${zipPath.replace(/'/g, "''")}'`,
      `-DestinationPath '${tmp.replace(/'/g, "''")}'`,
      '-Force',
    ].join(' ');
    const r = spawnSync('powershell', ['-NoProfile', '-Command', ps], {
      stdio: 'inherit',
    });
    if (r.status !== 0) die('Expand-Archive failed');
  } else {
    const r = spawnSync('unzip', ['-o', zipPath, '-d', tmp], { stdio: 'inherit' });
    if (r.status !== 0) die('unzip failed');
  }

  const needed = ['trusttunnel_client.exe', 'wintun.dll'];
  ensureDir(OUT_DIR);
  for (const name of needed) {
    const src = path.join(tmp, name);
    if (!fs.existsSync(src)) die(`missing ${name} in archive`);
    const dest = path.join(OUT_DIR, name);
    fs.copyFileSync(src, dest);
    console.log(`ok ${dest}`);
  }
}

if (process.platform !== 'win32') {
  console.log('TrustTunnel Windows CLI is only needed for Windows desktop builds.');
  process.exit(0);
}

download(ZIP_URL, CACHE);
extractZip(CACHE);
console.log('Done. Next: flutter build windows');
