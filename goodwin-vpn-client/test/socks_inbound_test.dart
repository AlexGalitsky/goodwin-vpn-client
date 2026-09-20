import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/session/socks_inbound.dart';

void main() {
  test('custom user+pass wins over session', () {
    final socks = SocksInbound.resolve(
      port: 19080,
      username: 'alice',
      password: 'secret',
      sessionUsername: 'old',
      sessionPassword: 'old',
      reuseSession: true,
    );
    expect(socks.port, 19080);
    expect(socks.username, 'alice');
    expect(socks.password, 'secret');
  });

  test('restore reuses session when user fields empty', () {
    final socks = SocksInbound.resolve(
      port: 10808,
      username: '',
      password: '',
      sessionUsername: 'sess',
      sessionPassword: 'sesspass',
      reuseSession: true,
    );
    expect(socks.username, 'sess');
    expect(socks.password, 'sesspass');
  });

  test('auto generates when empty and not restoring', () {
    var n = 0;
    final socks = SocksInbound.resolve(
      port: 0,
      username: '',
      password: '',
      sessionUsername: '',
      sessionPassword: '',
      reuseSession: false,
      randomSecret: () => 'r${n++}',
    );
    expect(socks.port, 10808);
    expect(socks.username, 'r0');
    expect(socks.password, 'r1');
  });
}
