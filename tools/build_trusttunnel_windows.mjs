#!/usr/bin/env node
/**
 * Build TrustTunnel Windows `vpn_easy` from refs/TrustTunnelClient and copy
 * artifact + headers into app/windows/libs/trusttunnel/.
 *
 * Prerequisites (Windows):
 *   - VS 2022 with C++ workload (+ CMake tools)
 *   - Conan 2 (`python -m pip install conan`)
 *   - Official NASM in `C:\Program Files\NASM` (not MinGW nasm)
 *   - Strawberry Perl, Rust, Git Bash (for bootstrap_conan_deps.sh)
 *
 * Critical: MinGW cmake/ninja/ccache from WinLibs via WinGet\Links crash Conan
 * (0xC0000139). This script imports vcvars and strips those paths.
 *
 * Usage (from repo root):
 *   node tools/setup_refs.mjs
 *   node tools/build_trusttunnel_windows.mjs
 *
 * Does NOT run the VPN — RDP-safe.
 */

import { spawnSync } from 'node:child_process';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const TT = path.join(ROOT, 'refs', 'TrustTunnelClient');
const OUT = path.join(ROOT, 'goodwin-vpn-client', 'windows', 'libs', 'trusttunnel');
const PLATFORM_WIN = path.join(TT, 'platform', 'windows');
const BUILD_DIR = path.join(PLATFORM_WIN, 'build');

function die(msg) {
  console.error(msg);
  process.exit(1);
}

function findVcvars() {
  const vswhere = path.join(
    process.env['ProgramFiles(x86)'] || 'C:\\Program Files (x86)',
    'Microsoft Visual Studio',
    'Installer',
    'vswhere.exe',
  );
  if (!fs.existsSync(vswhere)) return null;
  const r = spawnSync(
    vswhere,
    [
      '-latest',
      '-products',
      '*',
      '-requires',
      'Microsoft.VisualStudio.Component.VC.Tools.x86.x64',
      '-property',
      'installationPath',
    ],
    { encoding: 'utf8' },
  );
  const install = (r.stdout || '').trim();
  if (!install) return null;
  const bat = path.join(install, 'VC', 'Auxiliary', 'Build', 'vcvars64.bat');
  return fs.existsSync(bat) ? { install, bat } : null;
}

function findVsCmakeNinja(install) {
  const cmake = path.join(
    install,
    'Common7/IDE/CommonExtensions/Microsoft/CMake/CMake/bin/cmake.exe',
  );
  const ninja = path.join(
    install,
    'Common7/IDE/CommonExtensions/Microsoft/CMake/Ninja/ninja.exe',
  );
  if (!fs.existsSync(cmake) || !fs.existsSync(ninja)) {
    die('VS CMake/Ninja not found. Install C++ CMake tools for Visual Studio.');
  }
  return {
    cmake,
    ninja,
    cmakeBin: path.dirname(cmake),
    ninjaBin: path.dirname(ninja),
  };
}

function writePs1(body) {
  const ps1 = path.join(os.tmpdir(), 'goodwin_tt_build.ps1');
  fs.writeFileSync(ps1, body, 'utf8');
  return ps1;
}

function runPs1(ps1) {
  console.log(`> powershell -File ${ps1}`);
  const r = spawnSync(
    'powershell',
    ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', ps1],
    { stdio: 'inherit', shell: false },
  );
  if (r.error) throw r.error;
  if (r.status !== 0) die(`build failed (exit ${r.status})`);
}

function findFile(root, name) {
  const stack = [root];
  while (stack.length) {
    const dir = stack.pop();
    let entries;
    try {
      entries = fs.readdirSync(dir, { withFileTypes: true });
    } catch {
      continue;
    }
    for (const e of entries) {
      const p = path.join(dir, e.name);
      if (e.isDirectory()) stack.push(p);
      else if (e.name.toLowerCase() === name.toLowerCase()) return p;
    }
  }
  return null;
}

if (process.platform !== 'win32') {
  console.log('vpn_easy Windows build is only for win32.');
  process.exit(0);
}

if (!fs.existsSync(path.join(TT, 'CMakeLists.txt'))) {
  die(`Missing ${TT}. Run: node tools/setup_refs.mjs`);
}

const vs = findVcvars();
if (!vs) die('VS 2022 C++ tools not found (vcvars64.bat).');
const tools = findVsCmakeNinja(vs.install);
const nasmExe = 'C:\\Program Files\\NASM\\nasm.exe';
if (!fs.existsSync(nasmExe)) {
  die('Official NASM missing. Install: winget install NASM.NASM');
}

const pyRoot = path.join(process.env.LOCALAPPDATA || '', 'Programs', 'Python', 'Python313');
const pyScripts = path.join(pyRoot, 'Scripts');
const jobs = process.env.NUMBER_OF_PROCESSORS || '8';

const escapePs = (s) => s.replace(/'/g, "''");

console.log('1/3 bootstrap Conan recipe exports…');
runPs1(
  writePs1(`
$ErrorActionPreference = 'Stop'
function Import-VcVars($bat) {
  $tmp = Join-Path $env:TEMP 'vcvars_env.txt'
  cmd /c "\`"$bat\`" >nul && set" | Out-File -FilePath $tmp -Encoding ascii
  Get-Content $tmp | ForEach-Object {
    if ($_ -match '^(.*?)=(.*)$') { Set-Item -Path ("Env:" + $matches[1]) -Value $matches[2] }
  }
}
Import-VcVars '${escapePs(vs.bat)}'
$head = @(
  'C:\\Program Files\\NASM',
  '${escapePs(tools.cmakeBin)}',
  '${escapePs(tools.ninjaBin)}',
  '${escapePs(pyRoot)}',
  '${escapePs(pyScripts)}',
  'C:\\Strawberry\\perl\\bin'
)
$filtered = $env:PATH -split ';' | Where-Object {
  $_ -and $_ -notmatch 'WinGet\\\\Links|WinLibs|mingw64|Strawberry\\\\c\\\\bin'
}
$env:PATH = ($head + $filtered) -join ';'
Set-Location '${escapePs(TT)}'
python scripts\\bootstrap_conan_deps.py
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
`),
);

console.log('2/3 cmake configure + build vpn_easy (first Conan build can take a long time)…');
runPs1(
  writePs1(`
$ErrorActionPreference = 'Stop'
function Import-VcVars($bat) {
  $tmp = Join-Path $env:TEMP 'vcvars_env.txt'
  cmd /c "\`"$bat\`" >nul && set" | Out-File -FilePath $tmp -Encoding ascii
  Get-Content $tmp | ForEach-Object {
    if ($_ -match '^(.*?)=(.*)$') { Set-Item -Path ("Env:" + $matches[1]) -Value $matches[2] }
  }
}
Import-VcVars '${escapePs(vs.bat)}'
$head = @(
  'C:\\Program Files\\NASM',
  '${escapePs(tools.cmakeBin)}',
  '${escapePs(tools.ninjaBin)}',
  '${escapePs(pyRoot)}',
  '${escapePs(pyScripts)}',
  'C:\\Strawberry\\perl\\bin'
)
$filtered = $env:PATH -split ';' | Where-Object {
  $_ -and $_ -notmatch 'WinGet\\\\Links|WinLibs|mingw64|Strawberry\\\\c\\\\bin'
}
$env:PATH = ($head + $filtered) -join ';'
if (Get-Command ccache -ErrorAction SilentlyContinue) {
  Write-Error 'ccache still on PATH (MinGW) — abort'
  exit 1
}
$build = '${escapePs(BUILD_DIR)}'
if (Test-Path $build) { Remove-Item -Recurse -Force $build }
New-Item -ItemType Directory -Path $build | Out-Null
Set-Location $build
& '${escapePs(tools.cmake)}' -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_C_COMPILER=cl.exe -DCMAKE_CXX_COMPILER=cl.exe "-DCMAKE_MAKE_PROGRAM=${escapePs(tools.ninja)}" "-DCMAKE_ASM_NASM_COMPILER=${escapePs(nasmExe)}" ..
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& '${escapePs(tools.cmake)}' --build . --target vpn_easy -j ${jobs}
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
`),
);

console.log('3/3 copy artifact + headers + import lib…');
fs.mkdirSync(path.join(OUT, 'include', 'vpn'), { recursive: true });
const dll = findFile(BUILD_DIR, 'vpn_easy.dll');
if (!dll) die(`vpn_easy.dll not found under ${BUILD_DIR}`);
fs.copyFileSync(dll, path.join(OUT, 'vpn_easy.dll'));
const lib = findFile(BUILD_DIR, 'vpn_easy.lib');
if (!lib) die(`vpn_easy.lib not found under ${BUILD_DIR}`);
fs.copyFileSync(lib, path.join(OUT, 'vpn_easy.lib'));
fs.copyFileSync(
  path.join(PLATFORM_WIN, 'include', 'vpn', 'vpn_easy.h'),
  path.join(OUT, 'include', 'vpn', 'vpn_easy.h'),
);
const platformH = path.join(TT, 'common', 'include', 'vpn', 'platform.h');
if (fs.existsSync(platformH)) {
  fs.copyFileSync(platformH, path.join(OUT, 'include', 'vpn', 'platform.h'));
}

console.log(`ok ${path.join(OUT, 'vpn_easy.dll')} (${fs.statSync(path.join(OUT, 'vpn_easy.dll')).size} bytes)`);
console.log(`ok ${path.join(OUT, 'vpn_easy.lib')}`);
console.log(`ok ${path.join(OUT, 'include', 'vpn', 'vpn_easy.h')}`);
console.log('vpn_plugin links vpn_easy.lib and calls vpn_easy_start/stop (RDP-safe if no Connect).');
