import 'dart:convert';

import '../models/profiles.dart';
import '../xray/xray_support.dart';
import 'share_link.dart';
import 'uri_helpers.dart';

/// VMess share link: `vmess://` + base64(JSON).
XrayProfile parseVmess(String raw) {
  final uri = Uri.parse(raw);
  if (uri.scheme != 'vmess') {
    throw ShareLinkParseException('expected vmess://');
  }

  final payload = raw.substring('vmess://'.length).trim();
  late final Map<String, dynamic> json;
  try {
    final decoded = utf8.decode(base64.decode(_normalizeBase64(payload)));
    final dynamic parsed = jsonDecode(decoded);
    if (parsed is! Map<String, dynamic>) {
      throw ShareLinkParseException('vmess payload is not a JSON object');
    }
    json = parsed;
  } on FormatException catch (e) {
    throw ShareLinkParseException('invalid vmess base64/json: $e');
  }

  final address = '${json['add'] ?? ''}';
  final port = int.tryParse('${json['port'] ?? ''}');
  final id = '${json['id'] ?? ''}';
  if (address.isEmpty || port == null || id.isEmpty) {
    throw ShareLinkParseException('vmess missing add/port/id');
  }

  final tls = '${json['tls'] ?? ''}'.toLowerCase();
  final security = tls == 'tls' || tls == 'reality' ? tls : (tls.isEmpty ? 'none' : tls);
  final network = '${json['net'] ?? 'tcp'}';
  try {
    ensureSupportedXrayNetwork(network);
  } on FormatException catch (e) {
    throw ShareLinkParseException(e.message);
  }

  return XrayProfile(
    name: (json['ps'] as String?)?.trim().isNotEmpty == true
        ? (json['ps'] as String).trim()
        : address,
    protocol: XrayProtocol.vmess,
    address: address,
    port: port,
    id: id,
    encryption: 'auto',
    network: network,
    security: security,
    sni: emptyToNull('${json['sni'] ?? ''}'),
    fingerprint: emptyToNull('${json['fp'] ?? ''}'),
    publicKey: emptyToNull('${json['pbk'] ?? ''}'),
    shortId: emptyToNull('${json['sid'] ?? ''}'),
    wsPath: emptyToNull('${json['path'] ?? ''}'),
    wsHost: emptyToNull('${json['host'] ?? ''}'),
    alpn: emptyToNull('${json['alpn'] ?? ''}'),
    alterId: int.tryParse('${json['aid'] ?? '0'}') ?? 0,
    vmessSecurity: emptyToNull('${json['scy'] ?? 'auto'}') ?? 'auto',
  );
}

String _normalizeBase64(String input) {
  var s = input.replaceAll('-', '+').replaceAll('_', '/');
  final mod = s.length % 4;
  if (mod > 0) s = s.padRight(s.length + (4 - mod), '=');
  return s;
}
