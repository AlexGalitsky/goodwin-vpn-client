import '../models/profiles.dart';
import 'share_link.dart';
import 'uri_helpers.dart';

HysteriaProfile parseHysteria2(String raw) {
  final normalized =
      raw.startsWith('hy2://') ? 'hysteria2://${raw.substring(6)}' : raw;
  final uri = Uri.parse(normalized);
  if (uri.scheme != 'hysteria2') {
    throw ShareLinkParseException('expected hysteria2:// or hy2://');
  }

  final password = Uri.decodeComponent(uri.userInfo);
  final host = uri.host;
  final port = uri.port;
  if (password.isEmpty || host.isEmpty || port == 0) {
    throw ShareLinkParseException('hysteria2 missing password/host/port');
  }

  final q = queryMap(uri);
  final obfs = emptyToNull(q['obfs']);
  if (obfs != null) {
    throw ShareLinkParseException(
      'Hysteria2 obfs is not supported by this client',
    );
  }
  if (emptyToNull(q['obfs-password']) != null) {
    throw ShareLinkParseException(
      'Hysteria2 obfs-password is not supported by this client',
    );
  }

  return HysteriaProfile(
    name: fragmentName(uri, fallback: host),
    address: host,
    port: port,
    password: password,
    sni: emptyToNull(q['sni']),
    insecure: q['insecure'] == '1' || q['insecure'] == 'true',
  );
}
