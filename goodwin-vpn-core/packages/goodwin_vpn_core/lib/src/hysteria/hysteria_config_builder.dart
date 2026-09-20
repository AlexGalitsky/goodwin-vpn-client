import 'dart:convert';

import '../models/profiles.dart';

/// Client config JSON for [apernet/hysteria](https://github.com/apernet/hysteria) v2.
class HysteriaConfigBuilder {
  const HysteriaConfigBuilder({
    this.socksListen = '127.0.0.1',
    this.socksPort = 10808,
    this.socksUser = '',
    this.socksPass = '',
  });

  final String socksListen;
  final int socksPort;
  final String socksUser;
  final String socksPass;

  String buildJson(HysteriaProfile profile, {bool pretty = true}) {
    final map = buildMap(profile);
    return pretty ? const JsonEncoder.withIndent('  ').convert(map) : jsonEncode(map);
  }

  String resolveSni(HysteriaProfile profile) {
    return profile.sni ?? profile.address;
  }

  Map<String, dynamic> buildMap(HysteriaProfile profile) {
    if (profile.obfs != null || profile.obfsPassword != null) {
      throw FormatException(
        'Hysteria2 obfs is not supported by this client',
      );
    }
    final user = socksUser.trim();
    final pass = socksPass.trim();
    if (user.isEmpty || pass.isEmpty) {
      throw FormatException(
        'SOCKS username and password are required (noauth is not allowed)',
      );
    }
    final server = '${profile.address}:${profile.port}';
    final sni = resolveSni(profile);
    return {
      'server': server,
      'auth': profile.password,
      'tls': {
        'sni': sni,
        'insecure': profile.insecure,
      },
      'socks5': {
        'listen': '$socksListen:$socksPort',
        'username': user,
        'password': pass,
      },
    };
  }
}
