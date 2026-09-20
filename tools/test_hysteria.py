"""Smoke test: load libhysteria.dll, Start(config), curl via SOCKS5, Stop."""

from __future__ import annotations

import ctypes
import json
import struct
import subprocess
import sys
import time
from pathlib import Path
from urllib.parse import parse_qs, unquote, urlparse

ROOT = Path(__file__).resolve().parents[1]
DLL = ROOT / "cores" / "hysteria" / "build" / "libhysteria.dll"
URI = ROOT / "configs" / "secrets" / "hysteria2.url"
SOCKS_PORT = 10808
INSTANCE = b"smoke-hy2"
TEST_URL = "https://ifconfig.me/ip"
# Temporary: cert SAN is miranda, share-link host is ariel.
_SNI_OVERRIDES = {
    "ariel.goodwin.website": "miranda.goodwin.website",
}


def decode_response(ptr: int) -> tuple[int, int, str]:
    if not ptr:
        raise RuntimeError("null response pointer")
    raw = ctypes.string_at(ptr, 8)
    status, ctype = struct.unpack_from("<IH", raw, 0)
    body = ctypes.string_at(ptr + 8).decode("utf-8", errors="replace")
    return status, ctype, body


def uri_to_config(uri: str) -> dict:
    raw = uri.strip()
    if raw.startswith("hy2://"):
        raw = "hysteria2://" + raw[6:]
    u = urlparse(raw)
    if u.scheme != "hysteria2":
        raise ValueError("expected hysteria2://")
    password = unquote(u.username or "")
    host = u.hostname or ""
    port = u.port or 0
    if not password or not host or not port:
        raise ValueError("missing password/host/port")
    q = {k: v[0] for k, v in parse_qs(u.query).items()}
    cfg: dict = {
        "server": f"{host}:{port}",
        "auth": password,
        "socks5": {"listen": f"127.0.0.1:{SOCKS_PORT}"},
    }
    sni = _SNI_OVERRIDES.get(host) or q.get("sni") or host
    insecure = q.get("insecure") in ("1", "true")
    cfg["tls"] = {"sni": sni, "insecure": insecure}
    return cfg


def main() -> int:
    if not DLL.is_file():
        print(f"missing DLL: {DLL}", file=sys.stderr)
        return 1
    if not URI.is_file():
        print(f"missing {URI}", file=sys.stderr)
        return 1

    cfg = uri_to_config(URI.read_text(encoding="utf-8"))
    config_json = json.dumps(cfg).encode("utf-8")
    print(f"server={cfg['server']} socks={SOCKS_PORT}")

    lib = ctypes.CDLL(str(DLL))
    lib.Start.argtypes = [ctypes.c_char_p, ctypes.c_char_p]
    lib.Start.restype = ctypes.c_void_p
    lib.Stop.argtypes = [ctypes.c_char_p]
    lib.Stop.restype = None
    lib.IsStarted.argtypes = [ctypes.c_char_p]
    lib.IsStarted.restype = ctypes.c_int
    lib.FreePointer.argtypes = [ctypes.c_void_p]
    lib.FreePointer.restype = None
    lib.GetHysteriaVersion.argtypes = []
    lib.GetHysteriaVersion.restype = ctypes.c_void_p

    ver_ptr = lib.GetHysteriaVersion()
    try:
        _, _, ver = decode_response(ver_ptr)
        print(f"libhysteria: {ver}")
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

    time.sleep(0.5)
    try:
        out = subprocess.check_output(
            ["curl.exe", "-sS", "--max-time", "20", "--socks5-hostname", f"127.0.0.1:{SOCKS_PORT}", TEST_URL],
            text=True,
        ).strip()
        print(f"exit IP via proxy: {out}")
    except subprocess.CalledProcessError as e:
        print(f"curl failed: {e}", file=sys.stderr)
        lib.Stop(INSTANCE)
        return 1

    lib.Stop(INSTANCE)
    print("stopped")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
