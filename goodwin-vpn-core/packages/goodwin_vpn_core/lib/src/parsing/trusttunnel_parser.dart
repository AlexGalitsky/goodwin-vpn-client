import 'dart:convert';
import 'dart:typed_data';

import '../models/profiles.dart';
import 'share_link.dart';

/// Parses TrustTunnel `tt://?<base64url>` deep links (spec v1 TLV).
///
/// Spec: https://github.com/TrustTunnel/TrustTunnel/blob/master/DEEP_LINK.md
TrustTunnelProfile parseTrustTunnel(String raw) {
  final trimmed = raw.trim();
  final uri = Uri.tryParse(trimmed);
  if (uri == null || uri.scheme != 'tt') {
    throw ShareLinkParseException('expected tt://');
  }

  // Spec v1: tt://?<base64url>
  // Legacy / display: tt://host:port#Name (capture only)
  final payloadB64 = uri.query.isNotEmpty
      ? uri.query
      : (trimmed.contains('tt://?') ? trimmed.substring('tt://?'.length) : '');

  if (payloadB64.isEmpty) {
    final host = uri.host;
    final name = uri.fragment.isNotEmpty
        ? Uri.decodeComponent(uri.fragment)
        : (host.isNotEmpty ? host : 'trusttunnel');
    final endpoint = host.isNotEmpty ? (uri.hasPort ? '$host:${uri.port}' : host) : trimmed;
    return TrustTunnelProfile(
      name: name,
      endpoint: endpoint,
      rawDeepLink: trimmed,
    );
  }

  late final Uint8List bytes;
  try {
    bytes = _decodeBase64Url(payloadB64);
  } catch (e) {
    throw ShareLinkParseException('invalid tt:// base64url payload: $e');
  }

  final fields = _parseTlv(bytes);
  final version = fields.version;
  if (version > 1) {
    throw ShareLinkParseException('unsupported tt:// version $version (max 1)');
  }

  final hostname = fields.hostname;
  final addresses = fields.addresses;
  final username = fields.username;
  final password = fields.password;
  if (hostname == null || addresses.isEmpty || username == null || password == null) {
    throw ShareLinkParseException('tt:// missing required hostname/addresses/username/password');
  }

  final primary = addresses.first;
  return TrustTunnelProfile(
    name: fields.name?.isNotEmpty == true ? fields.name! : hostname,
    endpoint: primary,
    hostname: hostname,
    addresses: addresses,
    username: username,
    password: password,
    customSni: fields.customSni,
    hasIpv6: fields.hasIpv6,
    skipVerification: fields.skipVerification,
    upstreamProtocol: fields.upstreamProtocol,
    antiDpi: fields.antiDpi,
    dnsUpstreams: fields.dnsUpstreams,
    deepLinkVersion: version,
    rawDeepLink: trimmed,
  );
}

class _TtFields {
  int version = 0;
  String? hostname;
  final List<String> addresses = [];
  String? customSni;
  bool hasIpv6 = true;
  String? username;
  String? password;
  bool skipVerification = false;
  String? upstreamProtocol; // http2 | http3
  bool antiDpi = false;
  String? name;
  List<String> dnsUpstreams = [];
}

_TtFields _parseTlv(Uint8List data) {
  final out = _TtFields();
  var i = 0;
  while (i < data.length) {
    final tag = _readVarInt(data, i);
    i = tag.next;
    final len = _readVarInt(data, i);
    i = len.next;
    if (i + len.value > data.length) {
      throw ShareLinkParseException('tt:// TLV truncated');
    }
    final value = data.sublist(i, i + len.value);
    i += len.value;

    switch (tag.value) {
      case 0x00:
        out.version = _readVarInt(value, 0).value;
      case 0x01:
        out.hostname = utf8.decode(value);
      case 0x02:
        out.addresses.add(utf8.decode(value));
      case 0x03:
        out.customSni = utf8.decode(value);
      case 0x04:
        out.hasIpv6 = value.isNotEmpty && value[0] == 0x01;
      case 0x05:
        out.username = utf8.decode(value);
      case 0x06:
        out.password = utf8.decode(value);
      case 0x07:
        out.skipVerification = value.isNotEmpty && value[0] == 0x01;
      case 0x08:
        // certificate DER — keep in profile later if needed
        break;
      case 0x09:
        final proto = _readVarInt(value, 0).value;
        out.upstreamProtocol = proto == 0x02 ? 'http3' : 'http2';
      case 0x0A:
        out.antiDpi = value.isNotEmpty && value[0] == 0x01;
      case 0x0B:
        break; // client_random_prefix
      case 0x0C:
        out.name = utf8.decode(value);
      case 0x0D:
        out.dnsUpstreams = _readStringList(value);
      default:
        break; // forward-compatible
    }
  }
  return out;
}

({int value, int next}) _readVarInt(Uint8List data, int offset) {
  if (offset >= data.length) {
    throw ShareLinkParseException('tt:// varint truncated');
  }
  final first = data[offset];
  final prefix = first >> 6;
  final len = 1 << prefix;
  if (offset + len > data.length) {
    throw ShareLinkParseException('tt:// varint truncated');
  }
  var v = first & 0x3f;
  for (var j = 1; j < len; j++) {
    v = (v << 8) | data[offset + j];
  }
  return (value: v, next: offset + len);
}

List<String> _readStringList(Uint8List value) {
  final out = <String>[];
  var i = 0;
  while (i < value.length) {
    final len = _readVarInt(value, i);
    i = len.next;
    if (i + len.value > value.length) break;
    out.add(utf8.decode(value.sublist(i, i + len.value)));
    i += len.value;
  }
  return out;
}

Uint8List _decodeBase64Url(String input) {
  var s = input.replaceAll('-', '+').replaceAll('_', '/');
  final mod = s.length % 4;
  if (mod > 0) s = s.padRight(s.length + (4 - mod), '=');
  return Uint8List.fromList(base64.decode(s));
}
