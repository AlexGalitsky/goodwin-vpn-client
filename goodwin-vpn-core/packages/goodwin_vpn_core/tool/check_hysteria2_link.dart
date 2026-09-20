import 'dart:io';

import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';

void main() {
  var dir = Directory.current;
  File? file;
  for (var i = 0; i < 8; i++) {
    final candidate = File(
      '${dir.path}${Platform.pathSeparator}configs${Platform.pathSeparator}secrets${Platform.pathSeparator}hysteria2.url',
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
    stderr.writeln('missing hysteria2.url');
    exit(2);
  }
  final profile = const ShareLinkParser().parse(file.readAsStringSync().trim());
  if (profile is! HysteriaProfile) {
    stderr.writeln('not HysteriaProfile');
    exit(3);
  }
  stdout.writeln(
    'parse_ok=true name_len=${profile.name.length} port=${profile.port} '
    'sni=${profile.sni != null} insecure=${profile.insecure} obfs=${profile.obfs != null}',
  );
}
