#!/usr/bin/env node
/**
 * Store / Review locks for iOS Packet Tunnel (A2.3).
 *
 * - No Personal VPN (`allow-vpn`) and no App Groups on iOS entitlements.
 * - Appex DisplayName / name is GoodWin VPN, not SocksTunnel / Extension.
 * - Appex marketing/build versions match app/pubspec.yaml.
 * - Kill Switch excludes APNs / cellular / device communication.
 *
 * Usage (repo root): node tools/check_ios_store.mjs
 */

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

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

const pubspec = read('goodwin-vpn-client/pubspec.yaml');
const ver = pubspec.match(/^version:\s*(\d+\.\d+\.\d+)\+(\d+)\s*$/m);
if (!ver) die('goodwin-vpn-client/pubspec.yaml: expected version: x.y.z+n');
const marketing = ver[1];
const build = ver[2];
const escapeRe = (s) => s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');

const entitlements = [
  'goodwin-vpn-client/ios/Runner/Runner.entitlements',
  'goodwin-vpn-client/ios/Extension/Extension.entitlements',
  'goodwin-vpn-client/ios/SocksTunnel/Extension.entitlements',
];
for (const rel of entitlements) {
  const xml = read(rel);
  if (xml.includes('allow-vpn')) {
    die(`${rel}: Personal VPN (allow-vpn) must stay out — Review will ask`);
  }
  if (xml.includes('application-groups') || xml.includes('app-groups')) {
    die(`${rel}: App Groups are unused and break signing if the group is missing on the portal`);
  }
  if (!xml.includes('packet-tunnel-provider')) {
    die(`${rel}: Packet Tunnel entitlement is required`);
  }
}

const pbx = read('goodwin-vpn-client/ios/Runner.xcodeproj/project.pbxproj');
if (pbx.includes('INFOPLIST_KEY_CFBundleDisplayName = SocksTunnel')) {
  die('pbxproj: SocksTunnel DisplayName would show in Settings VPN');
}
if (pbx.includes('INFOPLIST_KEY_CFBundleDisplayName = Extension')) {
  die('pbxproj: Extension DisplayName would show in Settings VPN');
}
const displayHits = pbx.match(/INFOPLIST_KEY_CFBundleDisplayName = "GoodWin VPN";/g) ?? [];
if (displayHits.length < 6) {
  die(`pbxproj: expected GoodWin VPN DisplayName on both appex configs, got ${displayHits.length}`);
}
const nameHits = pbx.match(/INFOPLIST_KEY_CFBundleName = "GoodWin VPN";/g) ?? [];
if (nameHits.length < 6) {
  die(`pbxproj: expected GoodWin VPN CFBundleName on both appex configs, got ${nameHits.length}`);
}

const marketingHits =
  pbx.match(new RegExp(`MARKETING_VERSION = ${escapeRe(marketing)};`, 'g')) ?? [];
if (marketingHits.length < 6) {
  die(
    `pbxproj: appex MARKETING_VERSION must be ${marketing} (pubspec), got ${marketingHits.length} hits`,
  );
}
const buildHits = pbx.match(new RegExp(`CURRENT_PROJECT_VERSION = ${build};`, 'g')) ?? [];
if (buildHits.length < 6) {
  die(
    `pbxproj: appex CURRENT_PROJECT_VERSION must be ${build} (pubspec), got ${buildHits.length} hits`,
  );
}

for (const rel of ['goodwin-vpn-client/ios/SocksTunnel/Info.plist', 'goodwin-vpn-client/ios/Extension/Info.plist']) {
  const plist = read(rel);
  if (!plist.includes('<string>GoodWin VPN</string>')) {
    die(`${rel}: CFBundleDisplayName / CFBundleName must be GoodWin VPN`);
  }
  if (/<key>CFBundle(?:Display)?Name<\/key>\s*<string>\$\(PRODUCT_NAME\)<\/string>/.test(plist)) {
    die(`${rel}: PRODUCT_NAME would leak SocksTunnel / Extension into Settings`);
  }
}

const socks = read('goodwin-vpn-client/ios/Runner/SocksVpnManager.swift');
if (!socks.includes('localizedDescription = "GoodWin VPN"')) {
  die('SocksVpnManager: Settings VPN description must be GoodWin VPN');
}
for (const token of ['excludeAPNs', 'excludeCellularServices', 'excludeDeviceCommunication']) {
  if (!socks.includes(token)) {
    die(`SocksVpnManager: Kill Switch must set ${token} so Push / Watch / iMessage stay up`);
  }
}

console.log(
  `iOS store lock OK — ${marketing}+${build}, Packet Tunnel only, Settings name GoodWin VPN`,
);
