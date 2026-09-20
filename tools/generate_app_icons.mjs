#!/usr/bin/env node
/**
 * Rasterize launcher icons from app/assets/appicon.png (ffmpeg).
 *
 * Usage (from repo root):
 *   node tools/generate_app_icons.mjs
 */

import { spawnSync } from 'node:child_process';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const SRC = path.join(ROOT, 'goodwin-vpn-client', 'assets', 'appicon.png');

function die(msg) {
  console.error(msg);
  process.exit(1);
}

function run(cmd, args, opts = {}) {
  const r = spawnSync(cmd, args, { stdio: 'inherit', ...opts });
  if (r.error) throw r.error;
  if (r.status !== 0) die(`${cmd} ${args.join(' ')} failed (exit ${r.status})`);
}

function which(bin) {
  const r = spawnSync(process.platform === 'win32' ? 'where' : 'which', [bin], {
    encoding: 'utf8',
    shell: process.platform === 'win32',
  });
  return r.status === 0 ? r.stdout.trim().split(/\r?\n/)[0] : null;
}

function pngSize(file) {
  const buf = fs.readFileSync(file);
  if (buf.toString('ascii', 1, 4) !== 'PNG') die(`${file} is not PNG`);
  return { w: buf.readUInt32BE(16), h: buf.readUInt32BE(20) };
}

function rawRgba(file, w, h) {
  const r = spawnSync(
    'ffmpeg',
    ['-hide_banner', '-loglevel', 'error', '-i', file, '-f', 'rawvideo', '-pix_fmt', 'rgba', '-'],
    { encoding: 'buffer', maxBuffer: w * h * 4 + 1_000_000 },
  );
  if (r.status !== 0) die(`ffmpeg raw dump failed: ${r.stderr?.toString() || r.status}`);
  if (r.stdout.length < w * h * 4) die(`unexpected raw size ${r.stdout.length}`);
  return r.stdout;
}

function contentBox(rgba, w, h) {
  let minX = w;
  let minY = h;
  let maxX = -1;
  let maxY = -1;
  for (let y = 0; y < h; y++) {
    for (let x = 0; x < w; x++) {
      const i = (y * w + x) * 4;
      const a = rgba[i + 3];
      if (a < 20) continue;
      const lum = Math.max(rgba[i], rgba[i + 1], rgba[i + 2]);
      if (lum < 18) continue;
      if (x < minX) minX = x;
      if (y < minY) minY = y;
      if (x > maxX) maxX = x;
      if (y > maxY) maxY = y;
    }
  }
  if (maxX < 0) die('appicon.png looks empty (all near-black)');
  const pad = 2;
  minX = Math.max(0, minX - pad);
  minY = Math.max(0, minY - pad);
  maxX = Math.min(w - 1, maxX + pad);
  maxY = Math.min(h - 1, maxY + pad);
  const side = Math.max(maxX - minX + 1, maxY - minY + 1);
  let cx = Math.floor((minX + maxX + 1 - side) / 2);
  let cy = Math.floor((minY + maxY + 1 - side) / 2);
  cx = Math.max(0, Math.min(cx, w - side));
  cy = Math.max(0, Math.min(cy, h - side));
  return { x: cx, y: cy, w: side, h: side };
}

function ffmpegOut(args) {
  run('ffmpeg', ['-y', '-hide_banner', '-loglevel', 'error', ...args]);
}

function writePng(src, dest, size, { flatten = false } = {}) {
  fs.mkdirSync(path.dirname(dest), { recursive: true });
  const vf = flatten
    ? `scale=${size}:${size}:flags=lanczos,format=rgb24`
    : `scale=${size}:${size}:flags=lanczos`;
  ffmpegOut(['-i', src, '-vf', vf, dest]);
}

function pngToIco(pngs, dest) {
  const entries = [];
  let offset = 6 + 16 * pngs.length;
  for (const png of pngs) {
    const { w, h } = pngSize(png.path);
    entries.push({ w: w >= 256 ? 0 : w, h: h >= 256 ? 0 : h, bytes: png.buf, offset });
    offset += png.buf.length;
  }
  const header = Buffer.alloc(6);
  header.writeUInt16LE(0, 0);
  header.writeUInt16LE(1, 2);
  header.writeUInt16LE(pngs.length, 4);
  const table = Buffer.alloc(16 * pngs.length);
  for (let i = 0; i < entries.length; i++) {
    const e = entries[i];
    const o = i * 16;
    table[o] = e.w;
    table[o + 1] = e.h;
    table[o + 2] = 0;
    table[o + 3] = 0;
    table.writeUInt16LE(1, o + 4);
    table.writeUInt16LE(32, o + 6);
    table.writeUInt32LE(e.bytes.length, o + 8);
    table.writeUInt32LE(e.offset, o + 12);
  }
  fs.mkdirSync(path.dirname(dest), { recursive: true });
  fs.writeFileSync(dest, Buffer.concat([header, table, ...pngs.map((p) => p.buf)]));
}

function main() {
  if (!which('ffmpeg')) die('ffmpeg not found in PATH');
  if (!fs.existsSync(SRC)) die(`missing ${SRC}`);

  const { w, h } = pngSize(SRC);
  const box = contentBox(rawRgba(SRC, w, h), w, h);
  console.log(`source ${w}x${h}; crop ${box.w}x${box.h} @ ${box.x},${box.y}`);

  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'gw-icon-'));
  const master = path.join(tmp, 'master.png');
  ffmpegOut([
    '-i',
    SRC,
    '-vf',
    `crop=${box.w}:${box.h}:${box.x}:${box.y},scale=1024:1024:flags=lanczos,format=rgba`,
    master,
  ]);

  const ios = path.join(ROOT, 'goodwin-vpn-client', 'ios', 'Runner', 'Assets.xcassets', 'AppIcon.appiconset');
  const iosSizes = [
    ['Icon-App-20x20@1x.png', 20],
    ['Icon-App-20x20@2x.png', 40],
    ['Icon-App-20x20@3x.png', 60],
    ['Icon-App-29x29@1x.png', 29],
    ['Icon-App-29x29@2x.png', 58],
    ['Icon-App-29x29@3x.png', 87],
    ['Icon-App-40x40@1x.png', 40],
    ['Icon-App-40x40@2x.png', 80],
    ['Icon-App-40x40@3x.png', 120],
    ['Icon-App-60x60@2x.png', 120],
    ['Icon-App-60x60@3x.png', 180],
    ['Icon-App-76x76@1x.png', 76],
    ['Icon-App-76x76@2x.png', 152],
    ['Icon-App-83.5x83.5@2x.png', 167],
    ['Icon-App-1024x1024@1x.png', 1024],
  ];
  for (const [name, size] of iosSizes) {
    writePng(master, path.join(ios, name), size, { flatten: true });
  }

  const mac = path.join(ROOT, 'goodwin-vpn-client', 'macos', 'Runner', 'Assets.xcassets', 'AppIcon.appiconset');
  for (const size of [16, 32, 64, 128, 256, 512, 1024]) {
    writePng(master, path.join(mac, `app_icon_${size}.png`), size);
  }

  const launch = path.join(
    ROOT,
    'app',
    'ios',
    'Runner',
    'Assets.xcassets',
    'LaunchImage.imageset',
  );
  writePng(master, path.join(launch, 'LaunchImage.png'), 168, { flatten: true });
  writePng(master, path.join(launch, 'LaunchImage@2x.png'), 336, { flatten: true });
  writePng(master, path.join(launch, 'LaunchImage@3x.png'), 504, { flatten: true });

  const androidRes = path.join(ROOT, 'goodwin-vpn-client', 'android', 'app', 'src', 'main', 'res');
  const mipmaps = [
    ['mipmap-mdpi', 48, 108],
    ['mipmap-hdpi', 72, 162],
    ['mipmap-xhdpi', 96, 216],
    ['mipmap-xxhdpi', 144, 324],
    ['mipmap-xxxhdpi', 192, 432],
  ];
  for (const [dir, launcher, foreground] of mipmaps) {
    writePng(master, path.join(androidRes, dir, 'ic_launcher.png'), launcher, { flatten: true });
    writePng(master, path.join(androidRes, dir, 'ic_launcher_round.png'), launcher, {
      flatten: true,
    });
    writePng(master, path.join(androidRes, dir, 'ic_launcher_foreground.png'), foreground);
  }

  const winTmp = [16, 32, 48, 256].map((size) => {
    const p = path.join(tmp, `win-${size}.png`);
    writePng(master, p, size, { flatten: true });
    return { path: p, buf: fs.readFileSync(p) };
  });
  pngToIco(winTmp, path.join(ROOT, 'goodwin-vpn-client', 'windows', 'runner', 'resources', 'app_icon.ico'));

  fs.rmSync(tmp, { recursive: true, force: true });
  console.log('Done. launcher icons updated from app/assets/appicon.png');
}

main();
