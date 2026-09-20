#!/usr/bin/env node
/**
 * Local CI parity with .github/workflows/ci.yml
 *
 * Usage (from repo root):
 *   node tools/ci.mjs
 */

import { spawnSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const REFS = path.join(ROOT, 'refs', 'trusttunnel-client', 'plugins', 'vpn_plugin');

function run(cmd, args, opts = {}) {
  console.log(`\n> ${cmd} ${args.join(' ')}`);
  const r = spawnSync(cmd, args, {
    stdio: 'inherit',
    shell: process.platform === 'win32',
    ...opts,
  });
  if (r.status !== 0) {
    process.exit(r.status ?? 1);
  }
}

run('node', [path.join(ROOT, 'tools', 'check_ios_store.mjs')]);
run('node', [path.join(ROOT, 'tools', 'check_android_store.mjs')]);

if (!fs.existsSync(REFS)) {
  run('node', [path.join(ROOT, 'tools', 'setup_refs.mjs')]);
}

run('dart', ['pub', 'get'], { cwd: path.join(ROOT, 'goodwin-vpn-core', 'packages', 'goodwin_vpn_core') });
run('dart', ['analyze'], { cwd: path.join(ROOT, 'goodwin-vpn-core', 'packages', 'goodwin_vpn_core') });
run('dart', ['test'], { cwd: path.join(ROOT, 'goodwin-vpn-core', 'packages', 'goodwin_vpn_core') });

run('flutter', ['pub', 'get'], { cwd: path.join(ROOT, 'goodwin-vpn-client') });
run('flutter', ['analyze'], { cwd: path.join(ROOT, 'goodwin-vpn-client') });
run('flutter', ['test'], { cwd: path.join(ROOT, 'goodwin-vpn-client') });

console.log('\nCI OK');
