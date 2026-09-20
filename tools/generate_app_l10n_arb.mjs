#!/usr/bin/env node
/**
 * Writes GoodWin app extra-locale ARB files from tools/l10n/app/*.json
 * using app/lib/l10n/app_en.arb as the key + placeholder template.
 *
 * Does not overwrite app_en.arb or app_ru.arb.
 *
 * Usage: node tools/generate_app_l10n_arb.mjs
 */

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const ARB_DIR = path.join(ROOT, 'goodwin-vpn-client', 'lib', 'l10n');
const OVERLAY_DIR = path.join(ROOT, 'tools', 'l10n', 'app');

const LOCALES = ['zh', 'ar', 'fa', 'id', 'tr', 'de', 'fr', 'es', 'pt', 'it', 'ja', 'ko', 'hi'];

const en = JSON.parse(fs.readFileSync(path.join(ARB_DIR, 'app_en.arb'), 'utf8'));
const stringKeys = Object.keys(en).filter((k) => !k.startsWith('@'));

function buildArb(locale, strings) {
  /** @type {Record<string, unknown>} */
  const arb = { '@@locale': locale };
  const missing = [];
  for (const key of stringKeys) {
    const value = strings[key];
    if (typeof value !== 'string' || value.trim() === '') {
      missing.push(key);
      arb[key] = en[key];
    } else {
      arb[key] = value;
    }
    const meta = en[`@${key}`];
    if (meta) arb[`@${key}`] = meta;
  }
  if (missing.length) {
    throw new Error(
      `${locale}: ${missing.length} missing keys (e.g. ${missing.slice(0, 8).join(', ')})`,
    );
  }
  return `${JSON.stringify(arb, null, 2)}\n`;
}

for (const locale of LOCALES) {
  const overlayPath = path.join(OVERLAY_DIR, `${locale}.json`);
  const strings = JSON.parse(fs.readFileSync(overlayPath, 'utf8'));
  const outPath = path.join(ARB_DIR, `app_${locale}.arb`);
  fs.writeFileSync(outPath, buildArb(locale, strings));
  console.log(`Wrote ${stringKeys.length} keys → ${path.relative(ROOT, outPath)}`);
}
