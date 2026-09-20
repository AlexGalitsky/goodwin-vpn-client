#!/usr/bin/env node
/**
 * Download wintun.dll (amd64) into app/windows/libs/.
 *
 * Usage (from repo root):
 *   node tools/setup_wintun.mjs
 */

import { spawnSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const OUT_DIR = path.join(ROOT, 'goodwin-vpn-client', 'windows', 'libs');
const DEST = path.join(OUT_DIR, 'wintun.dll');
const WINTUN_VERSION = '0.14.1';
const ZIP_URL = `https://www.wintun.net/builds/wintun-${WINTUN_VERSION}.zip`;
const CACHE = path.join(ROOT, '.cache', `wintun-${WINTUN_VERSION}.zip`);
/** Official zip is ~300KB+; partial curl resets leave tiny/corrupt files. */
const MIN_ZIP_BYTES = 50_000;

function die(msg) {
  console.error(msg);
  process.exit(1);
}

function ensureDir(dir) {
  fs.mkdirSync(dir, { recursive: true });
}

function isZipOk(file) {
  if (!fs.existsSync(file)) return false;
  const st = fs.statSync(file);
  if (st.size < MIN_ZIP_BYTES) return false;
  const fd = fs.openSync(file, 'r');
  const buf = Buffer.alloc(2);
  fs.readSync(fd, buf, 0, 2, 0);
  fs.closeSync(fd);
  return buf[0] === 0x50 && buf[1] === 0x4b; // 'PK'
}

function copyFromTrustTunnel() {
  const ttDll = path.join(OUT_DIR, 'trusttunnel', 'wintun.dll');
  if (!fs.existsSync(ttDll)) return false;
  ensureDir(OUT_DIR);
  fs.copyFileSync(ttDll, DEST);
  console.log(`ok ${DEST} (from trusttunnel)`);
  return true;
}

function download(url, dest) {
  ensureDir(path.dirname(dest));
  if (isZipOk(dest)) {
    console.log(`cache hit ${dest}`);
    return true;
  }
  if (fs.existsSync(dest)) {
    console.log(`removing corrupt cache (${fs.statSync(dest).size} bytes)`);
    fs.unlinkSync(dest);
  }

  console.log(`download ${url}…`);
  const curl = process.platform === 'win32' ? 'curl.exe' : 'curl';
  let r = spawnSync(
    curl,
    ['-fsSL', '--retry', '3', '--retry-all-errors', '-o', dest, url],
    { stdio: 'inherit' },
  );
  if (r.status === 0 && isZipOk(dest)) return true;
  if (fs.existsSync(dest)) fs.unlinkSync(dest);

  if (process.platform === 'win32') {
    console.log('curl failed — trying Invoke-WebRequest…');
    const ps = `Invoke-WebRequest -Uri '${url.replace(/'/g, "''")}' -OutFile '${dest.replace(/'/g, "''")}' -UseBasicParsing`;
    r = spawnSync('powershell', ['-NoProfile', '-Command', ps], { stdio: 'inherit' });
    if (r.status === 0 && isZipOk(dest)) return true;
    if (fs.existsSync(dest)) fs.unlinkSync(dest);
  }

  return false;
}

function extractZip(zipPath, dllDest) {
  if (process.platform === 'win32') {
    const tmp = path.join(ROOT, '.cache', 'wintun-extract');
    fs.rmSync(tmp, { recursive: true, force: true });
    ensureDir(tmp);
    const ps = [
      'Expand-Archive',
      `-Path '${zipPath.replace(/'/g, "''")}'`,
      `-DestinationPath '${tmp.replace(/'/g, "''")}'`,
      '-Force',
    ].join(' ');
    const r = spawnSync('powershell', ['-NoProfile', '-Command', ps], {
      stdio: 'inherit',
    });
    if (r.status !== 0) return false;
    const dll = path.join(tmp, 'wintun', 'bin', 'amd64', 'wintun.dll');
    if (!fs.existsSync(dll)) return false;
    ensureDir(path.dirname(dllDest));
    fs.copyFileSync(dll, dllDest);
    return true;
  }
  const r = spawnSync('unzip', ['-j', zipPath, 'wintun/bin/amd64/wintun.dll', '-d', OUT_DIR], {
    stdio: 'inherit',
  });
  return r.status === 0 && fs.existsSync(dllDest);
}

if (process.platform !== 'win32') {
  console.log('wintun.dll is only needed for Windows desktop builds.');
  process.exit(0);
}

ensureDir(OUT_DIR);

if (fs.existsSync(DEST) && fs.statSync(DEST).size > 10_000) {
  console.log(`ok ${DEST} (already present)`);
  process.exit(0);
}

if (!download(ZIP_URL, CACHE) || !extractZip(CACHE, DEST)) {
  console.log('official zip unavailable — trying TrustTunnel copy…');
  if (!copyFromTrustTunnel()) {
    die(
      'wintun setup failed. Retry later, or copy wintun.dll to app/windows/libs/ ' +
        '(or run node tools/setup_trusttunnel_windows.mjs first).',
    );
  }
  process.exit(0);
}

console.log(`ok ${DEST}`);
