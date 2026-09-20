"""Convert VLESS share link → Xray JSON client config."""

from __future__ import annotations

import json
from pathlib import Path
from urllib.parse import parse_qs, unquote, urlparse


def vless_to_xray_config(uri: str, *, socks_port: int = 10808) -> dict:
    uri = uri.strip()
    if not uri.startswith("vless://"):
        raise ValueError("expected vless:// URI")

    parsed = urlparse(uri)
    uuid = unquote(parsed.username or "")
    host = parsed.hostname
    port = parsed.port
    if not uuid or not host or not port:
        raise ValueError("vless URI missing uuid/host/port")

    q = {k: v[0] for k, v in parse_qs(parsed.query, keep_blank_values=True).items()}
    network = q.get("type", "tcp")
    security = q.get("security", "none")
    encryption = q.get("encryption", "none")

    stream: dict = {"network": network, "security": security}

    if security == "reality":
        stream["realitySettings"] = {
            "serverName": q.get("sni") or host,
            "fingerprint": q.get("fp") or "chrome",
            "publicKey": q.get("pbk") or "",
            "shortId": q.get("sid") or "",
            "spiderX": q.get("spx") or "",
        }
        if not stream["realitySettings"]["publicKey"]:
            raise ValueError("reality requires pbk=")
    elif security == "tls":
        stream["tlsSettings"] = {
            "serverName": q.get("sni") or host,
            "fingerprint": q.get("fp") or "chrome",
            "allowInsecure": q.get("allowInsecure", "0") in ("1", "true"),
        }

    if network == "grpc":
        mode = (q.get("mode") or "gun").lower()
        stream["grpcSettings"] = {
            "serviceName": q.get("serviceName") or "",
            "multiMode": mode in ("multi", "multiMode", "gun-multi"),
        }
    elif network == "ws":
        stream["wsSettings"] = {
            "path": q.get("path") or "/",
            "headers": {"Host": q.get("host") or q.get("sni") or host},
        }
    elif network == "tcp" and q.get("headerType") == "http":
        stream["tcpSettings"] = {
            "header": {
                "type": "http",
                "request": {"path": [q.get("path") or "/"], "headers": {"Host": [q.get("host") or host]}},
            }
        }

    return {
        "log": {"loglevel": "warning"},
        "inbounds": [
            {
                "tag": "socks-in",
                "listen": "127.0.0.1",
                "port": socks_port,
                "protocol": "socks",
                "settings": {"udp": True, "auth": "noauth"},
            }
        ],
        "outbounds": [
            {
                "tag": "proxy",
                "protocol": "vless",
                "settings": {
                    "vnext": [
                        {
                            "address": host,
                            "port": port,
                            "users": [
                                {
                                    "id": uuid,
                                    "encryption": encryption,
                                    "flow": q.get("flow") or "",
                                }
                            ],
                        }
                    ]
                },
                "streamSettings": stream,
            },
            {"tag": "direct", "protocol": "freedom"},
            {"tag": "block", "protocol": "blackhole"},
        ],
        "routing": {
            "domainStrategy": "AsIs",
            "rules": [{"type": "field", "inboundTag": ["socks-in"], "outboundTag": "proxy"}],
        },
    }


def main() -> None:
    root = Path(__file__).resolve().parents[1]
    uri = (root / "configs" / "secrets" / "vless.url").read_text(encoding="utf-8").strip()
    cfg = vless_to_xray_config(uri)
    out = root / "configs" / "secrets" / "xray-test.json"
    out.write_text(json.dumps(cfg, indent=2) + "\n", encoding="utf-8")
    print(f"wrote {out}")
    print(f"outbound {cfg['outbounds'][0]['settings']['vnext'][0]['address']}:{cfg['outbounds'][0]['settings']['vnext'][0]['port']} via {cfg['outbounds'][0]['streamSettings']['network']}/{cfg['outbounds'][0]['streamSettings']['security']}")


if __name__ == "__main__":
    main()
