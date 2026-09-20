import 'dart:math';

/// Local SOCKS5 inbound (always password-auth). Never `noauth`.
class SocksInbound {
  const SocksInbound({
    required this.port,
    required this.username,
    required this.password,
  });

  static const defaultPort = 10808;

  /// Deterministic pair for tests / [PassthroughConnectPolicyResolver].
  static const test = SocksInbound(
    port: defaultPort,
    username: 'gw',
    password: 'test',
  );

  final int port;
  final String username;
  final String password;

  static int clampPort(int port) {
    if (port < 1024 || port > 65535) return defaultPort;
    return port;
  }

  /// Custom user+pass if both set; else last session (restore); else random.
  static SocksInbound resolve({
    required int port,
    required String username,
    required String password,
    required String sessionUsername,
    required String sessionPassword,
    required bool reuseSession,
    String Function()? randomSecret,
  }) {
    final p = clampPort(port);
    final user = username.trim();
    final pass = password.trim();
    if (user.isNotEmpty && pass.isNotEmpty) {
      return SocksInbound(port: p, username: user, password: pass);
    }
    final sessionUser = sessionUsername.trim();
    final sessionPass = sessionPassword.trim();
    if (reuseSession && sessionUser.isNotEmpty && sessionPass.isNotEmpty) {
      return SocksInbound(port: p, username: sessionUser, password: sessionPass);
    }
    final gen = randomSecret ?? generateSocksSecret;
    return SocksInbound(port: p, username: gen(), password: gen());
  }
}

String generateSocksSecret([int length = 16]) {
  const alphabet =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random.secure();
  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => alphabet.codeUnitAt(random.nextInt(alphabet.length)),
    ),
  );
}
