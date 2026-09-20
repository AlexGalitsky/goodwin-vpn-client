import 'dart:io';

/// Prefill from local secrets when running from the monorepo (desktop).
String? loadDefaultShareLink() {
  if (Platform.environment['FLUTTER_TEST'] == 'true') return null;
  try {
    var dir = Directory.current;
    for (var i = 0; i < 8; i++) {
      for (final name in ['hysteria2.url', 'trusttunnel.url', 'vless.url']) {
        final file = File(
          '${dir.path}${Platform.pathSeparator}configs${Platform.pathSeparator}secrets${Platform.pathSeparator}$name',
        );
        if (file.existsSync()) {
          return file.readAsStringSync().trim();
        }
      }
      final parent = dir.parent;
      if (parent.path == dir.path) break;
      dir = parent;
    }
  } catch (_) {}
  return null;
}
