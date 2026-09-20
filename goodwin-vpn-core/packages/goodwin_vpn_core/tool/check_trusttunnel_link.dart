import 'dart:io';

import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';

/// Smoke: parse configs/secrets/trusttunnel.url without printing secrets.
///
/// From package dir: `dart run tool/check_trusttunnel_link.dart`
void main() {
  var dir = Directory.current;
  File? file;
  for (var i = 0; i < 8; i++) {
    final candidate = File(
      '${dir.path}${Platform.pathSeparator}configs${Platform.pathSeparator}secrets${Platform.pathSeparator}trusttunnel.url',
    );
    if (candidate.existsSync()) {
      file = candidate;
      break;
    }
    final parent = dir.parent;
    if (parent.path == dir.path) break;
    dir = parent;
  }
  if (file == null) {
    stderr.writeln('missing configs/secrets/trusttunnel.url');
    exit(2);
  }
  final raw = file.readAsStringSync().trim();
  final profile = const ShareLinkParser().parse(raw);
  if (profile is! TrustTunnelProfile) {
    stderr.writeln('not a TrustTunnelProfile');
    exit(3);
  }
  final ok = profile.hostname != null &&
      profile.addresses.isNotEmpty &&
      profile.username != null &&
      profile.password != null;
  stdout.writeln(
    'parse_ok=$ok name_len=${profile.name.length} '
    'addrs=${profile.addresses.length} proto=${profile.upstreamProtocol} ver=${profile.deepLinkVersion}',
  );
  exit(ok ? 0 : 4);
}
