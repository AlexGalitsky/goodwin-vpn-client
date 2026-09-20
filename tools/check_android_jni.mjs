#!/usr/bin/env node
/**
 * Fail if Android jniLibs is missing required .so files, or if ELF LOAD
 * segments are not 16 KB-aligned (Play 2026).
 *
 *   node tools/check_android_jni.mjs
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const JNI = path.join(ROOT, 'goodwin-vpn-client', 'android', 'app', 'src', 'main', 'jniLibs');
const ABIS = ['arm64-v8a', 'armeabi-v7a', 'x86_64'];
const LIBS = ['libxray.so', 'libhysteria.so', 'libhev-socks5-tunnel.so'];
const ALIGN_64 = ['arm64-v8a', 'x86_64'];
const ALIGN = 16384;

function die(msg) {
  console.error(msg);
  process.exit(1);
}

function readU16(buf, off, le) {
  return le ? buf.readUInt16LE(off) : buf.readUInt16BE(off);
}
function readU32(buf, off, le) {
  return le ? buf.readUInt32LE(off) : buf.readUInt32BE(off);
}
function readU64(buf, off, le) {
  const n = le ? buf.readBigUInt64LE(off) : buf.readBigUInt64BE(off);
  return Number(n);
}

function checkElf16k(file) {
  const buf = fs.readFileSync(file);
  if (buf.length < 64 || buf.toString('ascii', 0, 4) !== '\u007fELF') {
    die(`${file}: not ELF`);
  }
  const eiClass = buf[4];
  const le = buf[5] === 1;
  const is64 = eiClass === 2;
  const phoff = is64 ? readU64(buf, 32, le) : readU32(buf, 28, le);
  const phentsize = readU16(buf, is64 ? 54 : 42, le);
  const phnum = readU16(buf, is64 ? 56 : 44, le);
  let loads = 0;
  for (let i = 0; i < phnum; i++) {
    const off = phoff + i * phentsize;
    const type = readU32(buf, off, le);
    if (type !== 1) continue; // PT_LOAD
    loads++;
    const alignOff = is64 ? off + 48 : off + 28;
    const align = is64 ? readU64(buf, alignOff, le) : readU32(buf, alignOff, le);
    if (align < ALIGN) {
      die(`${file}: PT_LOAD p_align=${align} < ${ALIGN}`);
    }
  }
  if (loads === 0) die(`${file}: no PT_LOAD`);
}

if (!fs.existsSync(JNI)) {
  die(`missing jniLibs at ${JNI} — run: node tools/build_android_native.mjs`);
}

for (const abi of ABIS) {
  for (const lib of LIBS) {
    const file = path.join(JNI, abi, lib);
    if (!fs.existsSync(file)) die(`missing ${path.relative(ROOT, file)}`);
    // Play 16 KB page size applies to 64-bit libs. armeabi-v7a stays 4 KB.
    if (ALIGN_64.includes(abi)) checkElf16k(file);
    console.log(`ok ${abi}/${lib}`);
  }
}

console.log('Android jniLibs 16 KB ELF check OK');
