#!/usr/bin/env node
/**
 * Clone gitignored refs needed for builds (xray-cshare, hev, TrustTunnel plugin, …).
 *
 * Usage (from repo root):
 *   node tools/setup_refs.mjs
 */

import { spawnSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { HEV_PIN, HEV_URL } from './hev_pin.mjs';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const REFS = path.join(ROOT, 'refs');

const REPOS = [
  {
    dir: 'xray-cshare',
    url: 'https://github.com/VanyaKrotov/xray-cshare.git',
  },
  {
    dir: 'libXray',
    url: 'https://github.com/XTLS/libXray.git',
  },
  {
    dir: 'flutter-xray',
    url: 'https://github.com/codewithtamim/flutter-xray.git',
  },
  {
    dir: 'trusttunnel-client',
    url: 'https://github.com/TrustTunnel/TrustTunnelFlutterClient.git',
  },
  {
    dir: 'TrustTunnelClient',
    url: 'https://github.com/TrustTunnel/TrustTunnelClient.git',
  },
];

function run(cmd, args, opts = {}) {
  const r = spawnSync(cmd, args, { stdio: 'inherit', shell: process.platform === 'win32', ...opts });
  if (r.error) throw r.error;
  if (r.status !== 0) {
    console.error(`${cmd} failed (exit ${r.status})`);
    process.exit(r.status ?? 1);
  }
}

fs.mkdirSync(REFS, { recursive: true });

for (const repo of REPOS) {
  const dest = path.join(REFS, repo.dir);
  if (fs.existsSync(dest)) {
    console.log(`skip ${repo.dir} (exists)`);
    continue;
  }
  const args = ['clone'];
  if (repo.recursive) args.push('--recursive');
  args.push('--depth', '1', repo.url, dest);
  console.log(`clone ${repo.dir}…`);
  run('git', args);
}

function ensureHevPin() {
  const dest = path.join(REFS, 'hev-socks5-tunnel');
  if (!fs.existsSync(dest)) {
    console.log(`clone hev-socks5-tunnel @ ${HEV_PIN}…`);
    run('git', ['clone', '--recursive', '--branch', HEV_PIN, '--depth', '1', HEV_URL, dest]);
    return;
  }
  const tag = spawnSync('git', ['describe', '--tags', '--exact-match'], {
    cwd: dest,
    encoding: 'utf8',
    shell: process.platform === 'win32',
  });
  if ((tag.stdout || '').trim() === HEV_PIN) {
    console.log(`hev-socks5-tunnel already ${HEV_PIN}`);
    return;
  }
  console.log(`checkout hev-socks5-tunnel ${HEV_PIN}…`);
  run('git', ['fetch', '--tags', '--depth', '1', 'origin', `refs/tags/${HEV_PIN}:refs/tags/${HEV_PIN}`], {
    cwd: dest,
  });
  run('git', ['checkout', HEV_PIN], { cwd: dest });
  run('git', ['submodule', 'update', '--init', '--recursive'], { cwd: dest });
}

ensureHevPin();

function patchVpnPluginCompileSdk() {
  const gradle = path.join(
    REFS,
    'trusttunnel-client',
    'plugins',
    'vpn_plugin',
    'android',
    'build.gradle',
  );
  if (!fs.existsSync(gradle)) return;
  const src = fs.readFileSync(gradle, 'utf8');
  if (!src.includes('compileSdk = 34')) return;
  fs.writeFileSync(gradle, src.replace('compileSdk = 34', 'compileSdk = 36'));
  console.log('patched vpn_plugin compileSdk 34 → 36 (androidx.core 1.16)');
}

patchVpnPluginCompileSdk();
console.log('Done. refs ->', REFS);
console.log('Next: node tools/build_android_native.mjs');
