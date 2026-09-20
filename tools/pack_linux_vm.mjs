#!/usr/bin/env node
/**
 * Pack sources + prebuilt Linux .so for a Linux VM (TUN field test later).
 *
 * Does not include refs/ (large) or Windows artifacts.
 *
 * Usage (from repo root):
 *   node tools/build_linux_native.mjs
 *   node tools/pack_linux_vm.mjs
 *
 * On the VM:
 *   unzip goodwin-vpn-linux-vm.zip
 *   # Flutter Linux SDK + GTK
 *   cd goodwin-vpn-client && flutter build linux
 *   # .so already in linux/libs — CMake copies into the bundle
 *   # SOCKS: curl --socks5-hostname 127.0.0.1:10808 https://ifconfig.me/ip
 *   # TUN: not in this zip workflow yet — SystemTunnel Linux backend TBD (P-L3)
 */

import { spawnSync } from 'node:child_process';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const OUT = path.join(ROOT, '.cache', 'goodwin-vpn-linux-vm.zip');

function die(msg) {
  console.error(msg);
  process.exit(1);
}

const so = path.join(ROOT, 'goodwin-vpn-client', 'linux', 'libs', 'libxray.so');
if (!fs.existsSync(so)) {
  die('goodwin-vpn-client/linux/libs/libxray.so missing. Run: node tools/build_linux_native.mjs');
}

const staging = path.join(os.tmpdir(), `goodwin-linux-vm-${Date.now()}`);
const dest = path.join(staging, 'goodwinvpn');
fs.mkdirSync(dest, { recursive: true });

const files = [
  'README.md',
  'goodwin-vpn-client/pubspec.yaml',
  'goodwin-vpn-client/pubspec.lock',
  'goodwin-vpn-client/analysis_options.yaml',
  'goodwin-vpn-client/linux',
  'goodwin-vpn-client/lib',
  'goodwin-vpn-core/packages/goodwin_vpn_core',
  'goodwin-vpn-core/cores/hysteria',
  'tools/build_linux_native.mjs',
  'tools/pack_linux_vm.mjs',
  'tools/xray_cli',
  'docs/client/platforms/linux.md',
  'docs/client/architecture.md',
];

function copyTree(srcRel) {
  const src = path.join(ROOT, srcRel);
  if (!fs.existsSync(src)) {
    console.log(`skip missing ${srcRel}`);
    return;
  }
  const target = path.join(dest, srcRel);
  fs.mkdirSync(path.dirname(target), { recursive: true });
  const st = fs.statSync(src);
  if (st.isDirectory()) {
    fs.cpSync(src, target, {
      recursive: true,
      filter: (p) => {
        const base = path.basename(p);
        if (base === 'build' || base === '.dart_tool' || base === 'ephemeral') {
          return false;
        }
        return true;
      },
    });
  } else {
    fs.copyFileSync(src, target);
  }
}

for (const rel of files) copyTree(rel);

fs.writeFileSync(
  path.join(dest, 'LINUX_VM.md'),
  `# Linux VM pack

Prebuilt SOCKS cores: \`goodwin-vpn-client/linux/libs/libxray.so\` (+ libhysteria.so if present).

## On Ubuntu LTS

\`\`\`bash
sudo apt update
sudo apt install -y clang cmake ninja-build pkg-config libgtk-3-dev curl unzip
# install Flutter (linux desktop enabled)
cd goodwin-vpn-client
flutter pub get
flutter build linux
# bundle: build/linux/x64/release/bundle/
curl --socks5-hostname 127.0.0.1:10808 https://ifconfig.me/ip
\`\`\`

SOCKS-only works without TUN. System TUN (P-L3: /dev/net/tun, routes, DNS) is **not** in this pack — implement + test on this VM, not WSL.

Rebuild .so on the VM if needed:

\`\`\`bash
node tools/build_linux_native.mjs
\`\`\`
`,
  'utf8',
);

fs.mkdirSync(path.dirname(OUT), { recursive: true });
if (fs.existsSync(OUT)) fs.unlinkSync(OUT);

console.log(`zip ${staging} → ${OUT}`);
const r = spawnSync(
  'tar',
  ['-a', '-c', '-f', OUT, '-C', staging, 'goodwinvpn'],
  { stdio: 'inherit' },
);
if (r.status !== 0) die('tar zip failed');

console.log(`ok ${OUT} (${fs.statSync(OUT).size} bytes)`);
console.log('Copy this zip to the Linux VM. TUN stays on the VM.');
