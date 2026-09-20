import '../models/profiles.dart';
import '../xray/xray_support.dart';
import 'share_link.dart';
import 'uri_helpers.dart';

XrayProfile parseVless(String raw) {
  final uri = Uri.parse(raw);
  if (uri.scheme != 'vless') {
    throw ShareLinkParseException('expected vless://');
  }
  final id = uri.userInfo;
  final host = uri.host;
  final port = uri.port;
  if (id.isEmpty || host.isEmpty || port == 0) {
    throw ShareLinkParseException('vless missing uuid/host/port');
  }

  final q = queryMap(uri);
  final network = q['type'] ?? 'tcp';
  try {
    ensureSupportedXrayNetwork(network);
  } on FormatException catch (e) {
    throw ShareLinkParseException(e.message);
  }

  return XrayProfile(
    name: fragmentName(uri, fallback: host),
    protocol: XrayProtocol.vless,
    address: host,
    port: port,
    id: Uri.decodeComponent(id),
    encryption: q['encryption'] ?? 'none',
    flow: emptyToNull(q['flow']),
    network: network,
    security: q['security'] ?? 'none',
    sni: emptyToNull(q['sni']),
    fingerprint: emptyToNull(q['fp']),
    publicKey: emptyToNull(q['pbk']),
    shortId: emptyToNull(q['sid']),
    spiderX: emptyToNull(q['spx']),
    serviceName: emptyToNull(q['serviceName']),
    grpcMode: emptyToNull(q['mode']),
    wsPath: emptyToNull(q['path']),
    wsHost: emptyToNull(q['host']),
    alpn: emptyToNull(q['alpn']),
  );
}
