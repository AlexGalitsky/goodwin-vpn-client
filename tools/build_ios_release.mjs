#!/usr/bin/env node
/**
 * Release iOS IPA for `app/` (App Store Connect / TestFlight).
 *
 * macOS + Xcode + Apple Distribution for team NTG8YJ7M9U required.
 *
 * Prerequisites (repo root):
 *   node tools/setup_refs.mjs
 *   node tools/build_apple_native.mjs
 *
 * Usage:
 *   node tools/build_ios_release.mjs
 *   node tools/build_ios_release.mjs --skip-native
 *   node tools/build_ios_release.mjs --archive-only   # xcarchive, no IPA export
 */

import { spawnSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const APP = path.join(ROOT, 'goodwin-vpn-client');
const EXPORT_PLIST = path.join(APP, 'ios', 'ExportOptions.plist');
const TUN_A = path.join(APP, 'ios', 'SocksTunnel', 'libs', 'libgoodwin_vpn_tun.a');

function die(msg) {
  console.error(msg);
  process.exit(1);
}

function run(cmd, args, opts = {}) {
  console.log(`\n> ${cmd} ${args.join(' ')}`);
  const r = spawnSync(cmd, args, {
    stdio: 'inherit',
    shell: process.platform === 'win32',
    ...opts,
  });
  if (r.status !== 0) die(`${cmd} failed (exit ${r.status ?? 1})`);
}

function readVersion() {
  const pub = fs.readFileSync(path.join(APP, 'pubspec.yaml'), 'utf8');
  const m = pub.match(/^version:\s*(\d+\.\d+\.\d+)\+(\d+)\s*$/m);
  if (!m) die('goodwin-vpn-client/pubspec.yaml: expected version: x.y.z+n');
  return { marketing: m[1], build: m[2], label: `${m[1]}+${m[2]}` };
}

if (process.platform !== 'darwin') {
  die('iOS release builds require macOS + Xcode');
}

const args = new Set(process.argv.slice(2));
const skipNative = args.has('--skip-native');
const archiveOnly = args.has('--archive-only');
if ([...args].some((a) => !['--skip-native', '--archive-only'].includes(a))) {
  die('Usage: node tools/build_ios_release.mjs [--skip-native] [--archive-only]');
}

const ver = readVersion();
console.log(`iOS release ${ver.label}`);

run('node', [path.join(ROOT, 'tools', 'check_ios_store.mjs')]);

if (!fs.existsSync(EXPORT_PLIST)) {
  die(`missing ${path.relative(ROOT, EXPORT_PLIST)}`);
}

if (!skipNative || !fs.existsSync(TUN_A)) {
  if (!fs.existsSync(path.join(ROOT, 'refs', 'trusttunnel-client'))) {
    run('node', [path.join(ROOT, 'tools', 'setup_refs.mjs')]);
  }
  run('node', [path.join(ROOT, 'tools', 'build_apple_native.mjs')]);
} else {
  console.log('skip apple native (--skip-native, libgoodwin_vpn_tun.a present)');
}

run('flutter', ['pub', 'get'], { cwd: APP });
run('pod', ['install'], { cwd: path.join(APP, 'ios') });

if (archiveOnly) {
  run(
    'flutter',
    ['build', 'ipa', '--release', '--no-codesign'],
    { cwd: APP },
  );
  // flutter build ipa --no-codesign still produces an archive under build/ios/archive
  const archive = path.join(APP, 'build', 'ios', 'archive', 'Runner.xcarchive');
  if (fs.existsSync(archive)) {
    console.log(`\nArchive (unsigned): ${path.relative(ROOT, archive)}`);
  }
  console.log(
    'Open the archive in Xcode Organizer and Distribute when Apple Distribution is available.',
  );
  process.exit(0);
}

run(
  'flutter',
  [
    'build',
    'ipa',
    '--release',
    `--export-options-plist=${EXPORT_PLIST}`,
  ],
  { cwd: APP },
);

const ipaDir = path.join(APP, 'build', 'ios', 'ipa');
const archive = path.join(APP, 'build', 'ios', 'archive', 'Runner.xcarchive');
let ipa = null;
if (fs.existsSync(ipaDir)) {
  ipa = fs
    .readdirSync(ipaDir)
    .filter((n) => n.endsWith('.ipa'))
    .map((n) => path.join(ipaDir, n))[0];
}

console.log(`\niOS release OK — ${ver.label}`);
if (ipa) {
  const st = fs.statSync(ipa);
  console.log(`  ${path.relative(ROOT, ipa)}  (${(st.size / (1024 * 1024)).toFixed(1)} MiB)`);
} else {
  console.log('  IPA not found — export may have failed (need Apple Distribution cert).');
  if (fs.existsSync(archive)) {
    console.log(`  Archive present: ${path.relative(ROOT, archive)}`);
    console.log('  Open in Xcode → Distribute App → App Store Connect.');
  }
  process.exit(1);
}
