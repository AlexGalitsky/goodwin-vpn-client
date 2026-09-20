/**
 * Monorepo layout helpers for Goodwin VPN.
 *
 *   goodwinvpn/
 *     goodwin-vpn-client/     Flutter app (was app/)
 *     goodwin-vpn-core/
 *       packages/goodwin_vpn_core/
 *       cores/
 *     tools/
 *     refs/                   gitignored clones (setup_refs.mjs)
 *     marketing/store_screenshots/
 */

import path from 'node:path';
import { fileURLToPath } from 'node:url';

export const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
export const APP = path.join(ROOT, 'goodwin-vpn-client');
export const CORE = path.join(ROOT, 'goodwin-vpn-core');
export const CORE_PKG = path.join(CORE, 'packages', 'goodwin_vpn_core');
export const CORES = path.join(CORE, 'cores');
export const REFS = path.join(ROOT, 'refs');
export const MARKETING = path.join(ROOT, 'marketing');
export const STORE_SHOTS = path.join(MARKETING, 'store_screenshots');
