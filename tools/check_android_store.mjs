#!/usr/bin/env node
/**
 * Play / 16 KB source locks (A2.4). Does not need jniLibs — those are checked
 * by tools/check_android_jni.mjs after a native build / on release packaging.
 *
 * Usage (repo root): node tools/check_android_store.mjs
 */

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { HEV_PIN } from './hev_pin.mjs';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');

function die(msg) {
  console.error(msg);
  process.exit(1);
}

function read(rel) {
  const abs = path.join(ROOT, rel);
  if (!fs.existsSync(abs)) die(`missing ${rel}`);
  return fs.readFileSync(abs, 'utf8');
}

function walkNamed(dir, name, acc = []) {
  if (!fs.existsSync(dir)) return acc;
  for (const ent of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, ent.name);
    if (ent.isDirectory()) walkNamed(p, name, acc);
    else if (ent.name === name) acc.push(p);
  }
  return acc;
}

if (!/^\d+\.\d+\.\d+$/.test(HEV_PIN)) {
  die(`tools/hev_pin.mjs: HEV_PIN must be a tag like 2.17.1, got ${HEV_PIN}`);
}

const manifests = [
  ...walkNamed(path.join(ROOT, 'goodwin-vpn-client', 'android'), 'AndroidManifest.xml'),
];
if (manifests.length === 0) die('no AndroidManifest.xml under goodwin-vpn-client/android');

for (const file of manifests) {
  const xml = fs.readFileSync(file, 'utf8');
  if (xml.includes('SYSTEM_EXEMPTED')) {
    die(`${path.relative(ROOT, file)}: FOREGROUND_SERVICE_SYSTEM_EXEMPTED is unused and Play will ask`);
  }
}

const setup = read('tools/setup_refs.mjs');
const build = read('tools/build_android_native.mjs');
const jniCheck = read('tools/check_android_jni.mjs');
const gradle = read('goodwin-vpn-client/android/app/build.gradle.kts');

for (const [rel, src] of [
  ['tools/setup_refs.mjs', setup],
  ['tools/build_android_native.mjs', build],
]) {
  if (!src.includes("from './hev_pin.mjs'") && !src.includes('from "./hev_pin.mjs"')) {
    die(`${rel}: must import HEV_PIN from tools/hev_pin.mjs`);
  }
}

if (!build.includes("max-page-size=16384")) {
  die('build_android_native.mjs: 64-bit Go .so must pass -Wl,-z,max-page-size=16384');
}
if (!build.includes('APP_SUPPORT_FLEXIBLE_PAGE_SIZES=true')) {
  die('build_android_native.mjs: ndk-build must set APP_SUPPORT_FLEXIBLE_PAGE_SIZES=true');
}
if (!build.includes('check_android_jni.mjs')) {
  die('build_android_native.mjs: must run check_android_jni.mjs after copying .so');
}
if (!jniCheck.includes('16384')) {
  die('check_android_jni.mjs: must reject PT_LOAD align < 16384 on 64-bit ABIs');
}
if (!gradle.includes('check_android_jni.mjs')) {
  die('goodwin-vpn-client/android/app/build.gradle.kts: release packaging must run check_android_jni.mjs');
}

const vpnService = read(
  'goodwin-vpn-client/android/app/src/main/kotlin/website/goodwin/vpnclient/GoodwinVpnService.kt',
);
if (vpnService.includes('ic_lock_lock')) {
  die('GoodwinVpnService: FGS must not use the system lock placeholder icon');
}
if (!vpnService.includes('ic_stat_vpn')) {
  die('GoodwinVpnService: FGS small icon must be ic_stat_vpn');
}
if (!fs.existsSync(path.join(ROOT, 'goodwin-vpn-client/android/app/src/main/res/drawable/ic_stat_vpn.xml'))) {
  die('missing goodwin-vpn-client/android/app/src/main/res/drawable/ic_stat_vpn.xml');
}

console.log(
  `Android store lock OK — hev ${HEV_PIN}, no SYSTEM_EXEMPTED, 16 KB flags + release JNI gate, FGS ic_stat_vpn`,
);
