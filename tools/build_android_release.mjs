#!/usr/bin/env node
/**
 * Release Android APK and/or AAB for `app/`.
 *
 * Prerequisites (repo root):
 *   node tools/setup_refs.mjs
 *   node tools/build_android_native.mjs
 *   node tools/setup_android_release_keystore.mjs   # once per machine
 *
 * Usage:
 *   node tools/build_android_release.mjs           # apk + aab
 *   node tools/build_android_release.mjs --apk
 *   node tools/build_android_release.mjs --aab
 *   node tools/build_android_release.mjs --skip-native   # reuse existing jniLibs
 */

import { spawnSync } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const APP = path.join(ROOT, 'goodwin-vpn-client');
const KEY_PROPS = path.join(APP, 'android', 'key.properties');
const JNI = path.join(APP, 'android', 'app', 'src', 'main', 'jniLibs');

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

const args = new Set(process.argv.slice(2));
const wantApk = args.has('--apk') || (!args.has('--apk') && !args.has('--aab'));
const wantAab = args.has('--aab') || (!args.has('--apk') && !args.has('--aab'));
const skipNative = args.has('--skip-native');
if ([...args].some((a) => !['--apk', '--aab', '--skip-native'].includes(a))) {
  die('Usage: node tools/build_android_release.mjs [--apk] [--aab] [--skip-native]');
}

const ver = readVersion();
console.log(`Android release ${ver.label}`);

run('node', [path.join(ROOT, 'tools', 'check_android_store.mjs')]);

if (!fs.existsSync(KEY_PROPS)) {
  die(
    `Missing ${path.relative(ROOT, KEY_PROPS)}\n` +
      'Run once: node tools/setup_android_release_keystore.mjs',
  );
}

const hevSo = path.join(JNI, 'arm64-v8a', 'libhev-socks5-tunnel.so');
if (!skipNative || !fs.existsSync(hevSo)) {
  if (!fs.existsSync(path.join(ROOT, 'refs', 'hev-socks5-tunnel'))) {
    run('node', [path.join(ROOT, 'tools', 'setup_refs.mjs')]);
  }
  run('node', [path.join(ROOT, 'tools', 'build_android_native.mjs')]);
} else {
  console.log('skip native rebuild (--skip-native, jniLibs present)');
  run('node', [path.join(ROOT, 'tools', 'check_android_jni.mjs')]);
}

run('flutter', ['pub', 'get'], { cwd: APP });

const outputs = [];
if (wantApk) {
  run('flutter', ['build', 'apk', '--release'], { cwd: APP });
  const apk = path.join(APP, 'build', 'app', 'outputs', 'flutter-apk', 'app-release.apk');
  if (!fs.existsSync(apk)) die(`missing APK: ${apk}`);
  outputs.push(apk);
}
if (wantAab) {
  run('flutter', ['build', 'appbundle', '--release'], { cwd: APP });
  const aab = path.join(
    APP,
    'build',
    'app',
    'outputs',
    'bundle',
    'release',
    'app-release.aab',
  );
  if (!fs.existsSync(aab)) die(`missing AAB: ${aab}`);
  outputs.push(aab);
}

console.log(`\nAndroid release OK — ${ver.label}`);
for (const p of outputs) {
  const st = fs.statSync(p);
  console.log(`  ${path.relative(ROOT, p)}  (${(st.size / (1024 * 1024)).toFixed(1)} MiB)`);
}
