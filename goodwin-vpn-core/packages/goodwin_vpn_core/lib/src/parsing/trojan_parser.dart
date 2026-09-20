import '../models/profiles.dart';
import '../xray/xray_support.dart';
import 'share_link.dart';
import 'uri_helpers.dart';

XrayProfile parseTrojan(String raw) {
  final uri = Uri.parse(raw);
  if (uri.scheme != 'trojan') {
    throw ShareLinkParseException('expected trojan://');
  }

  final password = Uri.decodeComponent(uri.userInfo);
  final host = uri.host;
  final port = uri.port;
  if (password.isEmpty || host.isEmpty || port == 0) {
    throw ShareLinkParseException('trojan missing password/host/port');
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
    protocol: XrayProtocol.trojan,
    address: host,
    port: port,
    id: password,
    network: network,
    security: q['security'] ?? 'tls',
    sni: emptyToNull(q['sni']) ?? emptyToNull(q['peer']),
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
