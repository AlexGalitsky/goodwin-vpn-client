import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';
import 'package:test/test.dart';

void main() {
  test('builds hysteria2 client json with socks5', () {
    const profile = HysteriaProfile(
      name: 'Hy',
      address: 'hy.example',
      port: 443,
      password: 'secret',
      sni: 'hy.example',
    );
    final map = const HysteriaConfigBuilder(
      socksUser: 'gw',
      socksPass: 'test',
    ).buildMap(profile);
    expect(map['server'], 'hy.example:443');
    expect(map['auth'], 'secret');
    expect(map['socks5'], {
      'listen': '127.0.0.1:10808',
      'username': 'gw',
      'password': 'test',
    });
    expect((map['tls'] as Map)['sni'], 'hy.example');
  });

  test('uses profile sni as-is', () {
    const profile = HysteriaProfile(
      name: 'Hy',
      address: 'titan.goodwin.website',
      port: 443,
      password: 'secret',
      sni: 'titan.goodwin.website',
    );
    final map = const HysteriaConfigBuilder(
      socksUser: 'gw',
      socksPass: 'test',
    ).buildMap(profile);
    expect(map['server'], 'titan.goodwin.website:443');
    expect((map['tls'] as Map)['sni'], 'titan.goodwin.website');
  });

  test('buildMap rejects obfs profiles', () {
    const profile = HysteriaProfile(
      name: 'Hy',
      address: 'hy.example',
      port: 443,
      password: 'secret',
      obfs: 'salamander',
      obfsPassword: 'x',
    );
    expect(
      () => const HysteriaConfigBuilder().buildMap(profile),
      throwsA(isA<FormatException>()),
    );
  });
}
