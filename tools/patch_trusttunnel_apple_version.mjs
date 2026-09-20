#!/usr/bin/env node
/**
 * App Store rejects CFBundleShortVersionString like "1.1.5-rc.6"
 * inside TrustTunnelClient.framework. Rewrite to "1.1.5" in vendored
 * xcframeworks (Pods). Safe to re-run.
 *
 * Usage (from repo root):
 *   node tools/patch_trusttunnel_apple_version.mjs
 */

import { spawnSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const BUDDY = '/usr/libexec/PlistBuddy';
const ROOTS = [
  path.join(ROOT, 'goodwin-vpn-client', 'ios', 'Pods', 'TrustTunnelClient'),
  path.join(ROOT, 'goodwin-vpn-client', 'macos', 'Pods', 'TrustTunnelClient'),
];

function walkPlists(dir, out = []) {
  if (!fs.existsSync(dir)) return out;
  for (const name of fs.readdirSync(dir)) {
    const full = path.join(dir, name);
    let st;
    try {
      st = fs.lstatSync(full);
    } catch {
      continue;
    }
    if (st.isSymbolicLink()) continue;
    if (st.isDirectory()) walkPlists(full, out);
    else if (name === 'Info.plist') out.push(full);
  }
  return out;
}

function plistGet(file, key) {
  const r = spawnSync(BUDDY, ['-c', `Print :${key}`, file], { encoding: 'utf8' });
  return r.status === 0 ? r.stdout.trim() : '';
}

function storeVersion(ver) {
  const m = ver.match(/^(\d+(?:\.\d+){0,2})/);
  return m ? m[1] : '';
}

function main() {
  if (!fs.existsSync(BUDDY)) {
    console.error('PlistBuddy not found — skip (not macOS)');
    return;
  }
  let n = 0;
  for (const root of ROOTS) {
    for (const plist of walkPlists(root)) {
      const cur = plistGet(plist, 'CFBundleShortVersionString');
      if (!cur || !/[^\d.]/.test(cur)) continue;
      const next = storeVersion(cur);
      if (!next || next === cur) continue;
      const r = spawnSync(BUDDY, ['-c', `Set :CFBundleShortVersionString ${next}`, plist]);
      if (r.status !== 0) {
        console.error(`failed ${plist}`);
        process.exit(1);
      }
      console.log(`${path.relative(ROOT, plist)}: ${cur} → ${next}`);
      n++;
    }
  }
  console.log(n ? `patched ${n} Info.plist` : 'no prerelease CFBundleShortVersionString found');
}

main();
