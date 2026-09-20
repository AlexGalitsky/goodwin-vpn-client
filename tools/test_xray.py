"""Smoke test: load libxray.dll, Start(config), curl via SOCKS5, Stop."""

from __future__ import annotations

import ctypes
import json
import struct
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DLL = ROOT / "refs" / "xray-cshare" / "build" / "libxray.dll"
CONFIG = ROOT / "configs" / "secrets" / "xray-test.json"
SOCKS_PORT = 10808
INSTANCE = b"smoke-test"
TEST_URL = "https://ifconfig.me/ip"


def decode_response(ptr: int) -> tuple[int, int, str]:
    if not ptr:
        raise RuntimeError("null response pointer")
    raw = ctypes.string_at(ptr, 8)
    status, ctype = struct.unpack_from("<IH", raw, 0)
    body = ctypes.string_at(ptr + 8).decode("utf-8", errors="replace")
    return status, ctype, body


def main() -> int:
    sys.path.insert(0, str(ROOT / "tools"))
    from vless_to_xray_json import vless_to_xray_config

    if not DLL.is_file():
        print(f"missing DLL: {DLL}", file=sys.stderr)
        return 1

    uri_path = ROOT / "configs" / "secrets" / "vless.url"
    if not CONFIG.is_file():
        if not uri_path.is_file():
            print(f"missing {uri_path}", file=sys.stderr)
            return 1
        cfg = vless_to_xray_config(uri_path.read_text(encoding="utf-8"), socks_port=SOCKS_PORT)
        CONFIG.parent.mkdir(parents=True, exist_ok=True)
        CONFIG.write_text(json.dumps(cfg, indent=2) + "\n", encoding="utf-8")
        print(f"generated {CONFIG}")

    config_json = CONFIG.read_text(encoding="utf-8").encode("utf-8")
    lib = ctypes.CDLL(str(DLL))
    lib.Start.argtypes = [ctypes.c_char_p, ctypes.c_char_p]
    lib.Start.restype = ctypes.c_void_p
    lib.Stop.argtypes = [ctypes.c_char_p]
    lib.Stop.restype = None
    lib.IsStarted.argtypes = [ctypes.c_char_p]
    lib.IsStarted.restype = ctypes.c_int
    lib.FreePointer.argtypes = [ctypes.c_void_p]
    lib.FreePointer.restype = None
    lib.GetXrayCoreVersion.argtypes = []
    lib.GetXrayCoreVersion.restype = ctypes.c_void_p

    ver_ptr = lib.GetXrayCoreVersion()
    try:
        _, _, ver = decode_response(ver_ptr)
        print(f"xray-core: {ver}")
    finally:
        lib.FreePointer(ver_ptr)

    start_ptr = lib.Start(INSTANCE, config_json)
    try:
        status, ctype, body = decode_response(start_ptr)
        print(f"Start status={status} type={ctype} body={body}")
        if status != 0:
            return 1
    finally:
        lib.FreePointer(start_ptr)

    if lib.IsStarted(INSTANCE) != 1:
        print("IsStarted returned 0", file=sys.stderr)
        return 1

    time.sleep(1)
    print(f"probing {TEST_URL} via socks5://127.0.0.1:{SOCKS_PORT} ...")
    try:
        proc = subprocess.run(
            [
                "curl.exe",
                "-sS",
                "--max-time",
                "20",
                "--socks5-hostname",
                f"127.0.0.1:{SOCKS_PORT}",
                TEST_URL,
            ],
            capture_output=True,
            text=True,
            check=False,
        )
        if proc.returncode != 0:
            print(f"curl failed ({proc.returncode}): {proc.stderr.strip()}", file=sys.stderr)
            return 1
        ip = proc.stdout.strip()
        print(f"exit IP via proxy: {ip}")
    finally:
        lib.Stop(INSTANCE)
        print("stopped")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
