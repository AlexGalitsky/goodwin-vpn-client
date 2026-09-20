#!/usr/bin/env node
/**
 * Create a local Android upload keystore + key.properties for `app/`
 * (gitignored). Does not overwrite an existing .jks.
 *
 * Usage (from repo root):
 *   node tools/setup_android_release_keystore.mjs
 *   node tools/setup_android_release_keystore.mjs --print
 */

import { spawnSync } from 'node:child_process';
import crypto from 'node:crypto';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const KEYSTORE = path.join(ROOT, 'configs', 'secrets', 'android-release.jks');
const KEY_PROPS_LIST = [
  path.join(ROOT, 'goodwin-vpn-client', 'android', 'key.properties'),
];
const ALIAS = 'goodwin-vpn';

function die(msg) {
  console.error(msg);
  process.exit(1);
}

function findKeytool() {
  const exe = process.platform === 'win32' ? 'keytool.exe' : 'keytool';
  const candidates = [];
  if (process.env.JAVA_HOME) {
    candidates.push(path.join(process.env.JAVA_HOME, 'bin', exe));
  }
  if (process.platform === 'darwin') {
    candidates.push(
      '/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/keytool',
      '/usr/bin/keytool',
    );
  }
  if (process.platform === 'win32') {
    const pf = process.env['ProgramFiles'] || 'C:\\Program Files';
    const pf86 = process.env['ProgramFiles(x86)'] || 'C:\\Program Files (x86)';
    const local = process.env.LOCALAPPDATA || '';
    candidates.push(
      path.join(local, 'Programs', 'Android', 'Android Studio', 'jbr', 'bin', exe),
      path.join(pf, 'Android', 'Android Studio', 'jbr', 'bin', exe),
      path.join(pf86, 'Android', 'Android Studio', 'jbr', 'bin', exe),
    );
  }
  for (const p of candidates) {
    if (p && fs.existsSync(p)) return p;
  }
  const which = spawnSync(process.platform === 'win32' ? 'where' : 'which', [exe], {
    encoding: 'utf8',
  });
  const hit = (which.stdout || '').split(/\r?\n/).map((s) => s.trim()).find(Boolean);
  if (hit && fs.existsSync(hit)) return hit;
  return null;
}

function loadProperties(file) {
  const out = {};
  if (!fs.existsSync(file)) return out;
  for (const line of fs.readFileSync(file, 'utf8').split(/\r?\n/)) {
    const t = line.trim();
    if (!t || t.startsWith('#') || !t.includes('=')) continue;
    const i = t.indexOf('=');
    out[t.slice(0, i)] = t.slice(i + 1);
  }
  return out;
}

function printCert(keytool, storeFile, storePassword) {
  const listed = spawnSync(
    keytool,
    [
      '-list',
      '-v',
      '-keystore',
      storeFile,
      '-storepass',
      storePassword,
      '-alias',
      ALIAS,
    ],
    { encoding: 'utf8' },
  );
  if (listed.status !== 0) {
    die(listed.stderr || listed.stdout || 'keytool -list failed');
  }
  const sha =
    listed.stdout.match(/SHA-256:\s*([0-9A-Fa-f:]+)/)?.[1] ||
    listed.stdout.match(/SHA256:\s*([0-9A-Fa-f:]+)/)?.[1] ||
    '(not found)';
  console.log(`alias ${ALIAS}`);
  console.log(`SHA-256 ${sha}`);
}

function firstExistingProps() {
  for (const file of KEY_PROPS_LIST) {
    if (fs.existsSync(file)) return { file, props: loadProperties(file) };
  }
  return { file: null, props: {} };
}

function writeMissingKeyProperties({ storePassword, keyPassword, keyAlias }) {
  const storeFile = KEYSTORE.split(path.sep).join('/');
  const body = [
    `# Local only — never commit. Generated ${new Date().toISOString()} on ${os.hostname()}`,
    `storePassword=${storePassword}`,
    `keyPassword=${keyPassword}`,
    `keyAlias=${keyAlias}`,
    `storeFile=${storeFile}`,
    '',
  ].join('\n');
  let wrote = 0;
  for (const dest of KEY_PROPS_LIST) {
    if (fs.existsSync(dest)) {
      console.log(`exists ${dest}`);
      continue;
    }
    fs.mkdirSync(path.dirname(dest), { recursive: true });
    fs.writeFileSync(dest, body, { mode: 0o600 });
    console.log(`ok ${dest}`);
    wrote++;
  }
  return wrote;
}

const printOnly = process.argv.includes('--print');
const keytool = findKeytool();
if (!keytool) {
  die('keytool not found. Install a JDK or Android Studio JBR and retry.');
}

if (printOnly) {
  const { file, props } = firstExistingProps();
  const storeFile = props.storeFile || KEYSTORE;
  const storePassword = props.storePassword;
  if (!storePassword) {
    die(`missing storePassword in ${file || KEY_PROPS_LIST.join(', ')}`);
  }
  if (!fs.existsSync(storeFile)) die(`keystore not found: ${storeFile}`);
  printCert(keytool, storeFile, storePassword);
  process.exit(0);
}

if (fs.existsSync(KEYSTORE)) {
  const { file, props } = firstExistingProps();
  const storePassword = props.storePassword;
  const keyPassword = props.keyPassword || storePassword;
  const keyAlias = props.keyAlias || ALIAS;
  if (!storePassword) {
    die(
      `keystore exists at ${KEYSTORE} but no key.properties with storePassword ` +
        `(looked in ${KEY_PROPS_LIST.join(', ')})`,
    );
  }
  const wrote = writeMissingKeyProperties({
    storePassword,
    keyPassword,
    keyAlias,
  });
  if (wrote === 0) {
    console.log('keystore already exists — not overwriting.');
    console.log(`  ${KEYSTORE}`);
    if (file) console.log(`  ${file}`);
  }
  console.log('Print fingerprint: node tools/setup_android_release_keystore.mjs --print');
  process.exit(0);
}

const password = crypto.randomBytes(24).toString('base64url');
fs.mkdirSync(path.dirname(KEYSTORE), { recursive: true });

const generated = spawnSync(
  keytool,
  [
    '-genkeypair',
    '-v',
    '-keystore',
    KEYSTORE,
    '-storetype',
    'PKCS12',
    '-keyalg',
    'RSA',
    '-keysize',
    '2048',
    '-validity',
    '10000',
    '-alias',
    ALIAS,
    '-storepass',
    password,
    '-keypass',
    password,
    '-dname',
    'CN=Goodwin VPN, OU=Goodwin, O=Goodwin, L=Unknown, ST=Unknown, C=US',
  ],
  { encoding: 'utf8' },
);
if (generated.status !== 0) {
  if (fs.existsSync(KEYSTORE)) fs.unlinkSync(KEYSTORE);
  die(generated.stderr || generated.stdout || 'keytool -genkeypair failed');
}

fs.chmodSync(KEYSTORE, 0o600);
console.log(`ok ${KEYSTORE}`);
writeMissingKeyProperties({
  storePassword: password,
  keyPassword: password,
  keyAlias: ALIAS,
});
printCert(keytool, KEYSTORE, password);
console.log('');
console.log('Back up android-release.jks and key.properties offline.');
console.log('Losing them means you cannot update this app id with a new APK.');
