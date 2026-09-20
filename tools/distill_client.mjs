#!/usr/bin/env node
/**
 * Distill the public client slice from the monorepo — copy only, no path rewrite.
 *
 * Layout in OUT (same relative paths as monorepo):
 *   goodwin-vpn-client/
 *   goodwin-vpn-core/
 *   tools/
 *   configs/secrets/   (.gitkeep + README only)
 *   README.md
 *   .gitignore
 *
 * Usage (monorepo root):
 *   node tools/distill_client.mjs
 *   node tools/distill_client.mjs --out .cache/distill/goodwin-vpn-client
 *   node tools/distill_client.mjs --dry-run
 *   node tools/distill_client.mjs --clean
 *
 * Does not push. Docs / marketing / server / site are not included.
 */

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { ROOT } from './repo_paths.mjs';

const DEFAULT_OUT = path.join(ROOT, '.cache', 'distill', 'goodwin-vpn-client');

const COPY_ROOTS = [
  'goodwin-vpn-client',
  'goodwin-vpn-core',
  'tools',
  'configs',
];

/** Directory names skipped anywhere in the tree. */
const SKIP_DIRS = new Set([
  '.git',
  '.dart_tool',
  '.idea',
  '.vscode',
  '.gradle',
  '.symlinks',
  '.venv',
  'venv',
  'build',
  'ephemeral',
  'Pods',
  'node_modules',
  '__pycache__',
  'vendor',
  'upstream',
  'screenshots',
  'jniLibs',
]);

/** Exact basenames never copied. */
const SKIP_FILES = new Set([
  'llm-chat.md',
  'fingerprint.md',
  '.DS_Store',
  'Thumbs.db',
  'key.properties',
  'local.properties',
  '.flutter-plugins',
  '.flutter-plugins-dependencies',
  'figma-pat',
  'github-pat',
]);

const SKIP_EXT = [
  '.dll',
  '.so',
  '.dylib',
  '.a',
  '.lib',
  '.aar',
  '.jks',
  '.p12',
  '.iml',
  '.log',
];

/** Under configs/secrets/ only these basenames may be copied. */
const SECRETS_ALLOW = new Set(['.gitkeep', 'README.md']);

/** Paths that must never appear in OUT (relative posix). */
const FORBIDDEN_SUBSTRINGS = [
  'llm-chat.md',
  'fingerprint.md',
  'configs/secrets/vless.url',
  'configs/secrets/hysteria2.url',
  'configs/secrets/trusttunnel.url',
  'configs/secrets/github-pat',
  'configs/secrets/figma-pat',
  'configs/secrets/android-release',
  'key.properties',
];

function parseArgs(argv) {
  let out = DEFAULT_OUT;
  let dryRun = false;
  let clean = false;
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--dry-run') dryRun = true;
    else if (a === '--clean') clean = true;
    else if (a === '--out') {
      out = path.resolve(argv[++i] ?? '');
      if (!out) die('--out requires a path');
    } else if (a === '--help' || a === '-h') {
      printHelp();
      process.exit(0);
    } else {
      die(`unknown arg: ${a}`);
    }
  }
  return { out, dryRun, clean };
}

function printHelp() {
  console.log(`Usage: node tools/distill_client.mjs [--out DIR] [--clean] [--dry-run]

  --out DIR   Destination (default: .cache/distill/goodwin-vpn-client)
  --clean     Remove DIR before copy
  --dry-run   List actions only`);
}

function die(msg) {
  console.error(msg);
  process.exit(1);
}

function toPosix(p) {
  return p.split(path.sep).join('/');
}

function shouldSkip(relPosix, base) {
  const parts = relPosix.split('/').filter(Boolean);
  for (const part of parts) {
    if (SKIP_DIRS.has(part)) return true;
  }
  // Drop prebuilt desktop/mobile lib dirs (except keep empty README if any).
  if (parts.includes('libs')) {
    const i = parts.indexOf('libs');
    const parent = parts[i - 1];
    if (parent === 'windows' || parent === 'linux' || parent === 'macos') {
      if (base !== 'README.md') return true;
    }
  }
  if (SKIP_FILES.has(base)) return true;
  if (SKIP_EXT.some((ext) => base.endsWith(ext))) return true;
  if (relPosix.includes('configs/secrets/')) {
    if (!SECRETS_ALLOW.has(base)) return true;
  }
  return false;
}

function walkFiles(absDir, relBase, into) {
  if (!fs.existsSync(absDir)) {
    die(`missing source: ${relBase}`);
  }
  const entries = fs.readdirSync(absDir, { withFileTypes: true });
  for (const ent of entries) {
    const rel = relBase ? `${relBase}/${ent.name}` : ent.name;
    const abs = path.join(absDir, ent.name);
    if (ent.isDirectory()) {
      if (SKIP_DIRS.has(ent.name)) continue;
      // Still enter windows/libs to allow README.md
      walkFiles(abs, rel, into);
    } else if (ent.isFile() || ent.isSymbolicLink()) {
      if (shouldSkip(rel, ent.name)) continue;
      into.push({ abs, rel });
    }
  }
}

function ensureClean(out, dryRun) {
  if (!fs.existsSync(out)) return;
  console.log(`${dryRun ? 'would remove' : 'remove'} ${out}`);
  if (!dryRun) fs.rmSync(out, { recursive: true, force: true });
}

function copyFile(src, dest, dryRun) {
  if (dryRun) return;
  fs.mkdirSync(path.dirname(dest), { recursive: true });
  fs.copyFileSync(src, dest);
}

function writeFile(dest, content, dryRun) {
  if (dryRun) return;
  fs.mkdirSync(path.dirname(dest), { recursive: true });
  fs.writeFileSync(dest, content, 'utf8');
}

function publicReadme() {
  return `# GoodWin VPN client

Flutter VPN client: **Xray · Hysteria 2 · TrustTunnel**.

This repository is a distilled public slice of a private monorepo.
Relative paths match the monorepo (\`goodwin-vpn-client/\` + \`goodwin-vpn-core/\` + \`tools/\`).

## Layout

| Path | Role |
|------|------|
| \`goodwin-vpn-client/\` | Flutter app |
| \`goodwin-vpn-core/\` | Dart package + native core sources |
| \`tools/\` | Node build / setup scripts |
| \`configs/secrets/\` | Local secrets (gitignored; see README there) |

## Quick start (Windows)

\`\`\`powershell
node tools/setup_refs.mjs
node tools/build_host_native.mjs
node tools/setup_wintun.mjs
node tools/build_windows_tun2socks.mjs
cd goodwin-vpn-client
flutter pub get
flutter run -d windows
\`\`\`

Core tests:

\`\`\`powershell
cd goodwin-vpn-core/packages/goodwin_vpn_core
dart pub get
dart test
\`\`\`

Local CI parity: \`node tools/ci.mjs\`

\`refs/\` and native binaries (\`jniLibs/\`, \`windows/libs/\`, …) are **not** in git — build them locally.

## License

Proprietary / all rights reserved unless noted otherwise in-tree.
`;
}

function publicGitignore() {
  return `# Secrets & env
.env
.env.*
!.env.example
configs/secrets/*
!configs/secrets/.gitkeep
!configs/secrets/README.md

.cache/
refs/

*.dylib
*.so
*.dll
*.a
*.lib
*.aar
*.xcframework/
*.framework/
goodwin-vpn-client/android/app/src/main/jniLibs/
goodwin-vpn-client/windows/libs/
goodwin-vpn-client/linux/libs/
goodwin-vpn-client/macos/libs/*
!goodwin-vpn-client/macos/libs/README.md
goodwin-vpn-core/cores/**/upstream/

build/
**/build/
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
**/Generated.xcconfig
**/flutter_export_environment.sh

**/android/.gradle/
**/android/local.properties
**/android/app/debug/
**/android/app/profile/
**/android/app/release/
**/ios/Pods/
**/ios/.symlinks/
**/macos/Flutter/ephemeral/
**/linux/flutter/ephemeral/
**/windows/flutter/ephemeral/
*.apk
*.aab
*.ipa
*.appx
*.msix
*.jks
*.p12

.idea/
.vscode/
*.iml
.DS_Store
Thumbs.db

__pycache__/
*.py[cod]
.venv/
venv/

*.log
node_modules/

# Never publish local notes if reintroduced
llm-chat.md
fingerprint.md
`;
}

function assertSafe(out) {
  const violations = [];
  function walk(dir, rel) {
    for (const ent of fs.readdirSync(dir, { withFileTypes: true })) {
      const r = rel ? `${rel}/${ent.name}` : ent.name;
      const abs = path.join(dir, ent.name);
      if (ent.isDirectory()) walk(abs, r);
      else {
        const posix = toPosix(r);
        for (const bad of FORBIDDEN_SUBSTRINGS) {
          if (posix.includes(bad) || ent.name === bad) {
            violations.push(posix);
          }
        }
        if (ent.name.endsWith('.url') && posix.includes('secrets')) {
          violations.push(posix);
        }
      }
    }
  }
  walk(out, '');
  if (violations.length) {
    die(`distill safety check failed:\n  ${violations.join('\n  ')}`);
  }

  const pubspec = path.join(out, 'goodwin-vpn-client', 'pubspec.yaml');
  const corePub = path.join(
    out,
    'goodwin-vpn-core',
    'packages',
    'goodwin_vpn_core',
    'pubspec.yaml',
  );
  if (!fs.existsSync(pubspec)) die('missing goodwin-vpn-client/pubspec.yaml in OUT');
  if (!fs.existsSync(corePub)) die('missing goodwin-vpn-core package pubspec in OUT');

  const pubText = fs.readFileSync(pubspec, 'utf8');
  if (!pubText.includes('path: ../goodwin-vpn-core/packages/goodwin_vpn_core')) {
    die('client pubspec path dep on goodwin-vpn-core looks wrong — refuse to distill');
  }
}

function main() {
  const { out, dryRun, clean } = parseArgs(process.argv.slice(2));
  console.log(`distill client → ${out}${dryRun ? ' (dry-run)' : ''}`);

  if (clean) ensureClean(out, dryRun);

  const files = [];
  for (const root of COPY_ROOTS) {
    walkFiles(path.join(ROOT, root), root, files);
  }

  console.log(`copy ${files.length} files`);
  if (dryRun) {
    for (const f of files.slice(0, 40)) console.log(`  ${f.rel}`);
    if (files.length > 40) console.log(`  … +${files.length - 40} more`);
    console.log('would write README.md, .gitignore');
    console.log('dry-run OK (no safety scan on disk)');
    return;
  }

  fs.mkdirSync(out, { recursive: true });
  for (const f of files) {
    copyFile(f.abs, path.join(out, f.rel), false);
  }

  // Prefer distilled secrets README (no stale app/ paths).
  writeFile(
    path.join(out, 'configs', 'secrets', 'README.md'),
    `# Local secrets (not in git)

Put working connection strings here. This directory is gitignored except this README and \`.gitkeep\`.

| File | Protocol |
|------|----------|
| \`vless.url\` | Xray VLESS (one line) |
| \`trusttunnel.url\` | TrustTunnel \`tt://\` (one line) |
| \`hysteria2.url\` | Hysteria 2 (one line) |

Never commit \`*.url\`, \`github-pat\`, \`.env\`, or the Android upload keystore.

Android release signing:

\`\`\`bash
node tools/setup_android_release_keystore.mjs
\`\`\`

Writes \`configs/secrets/android-release.jks\` and \`goodwin-vpn-client/android/key.properties\` (both gitignored).
`,
    false,
  );

  writeFile(path.join(out, 'README.md'), publicReadme(), false);
  writeFile(path.join(out, '.gitignore'), publicGitignore(), false);

  // Drop monorepo-only distill helper from public tools? Keep it — useful to re-run from a fork of the slice is odd.
  // Keep distill_client.mjs: harmless; documents how the slice was produced.

  assertSafe(out);
  console.log('safety OK');
  console.log(`done → ${out}`);
  console.log('Next: cd into OUT, git init / remote, push when ready (not done by this script).');
}

main();
