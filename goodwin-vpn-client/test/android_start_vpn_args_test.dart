import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/android_vpn.dart';

void main() {
  group('androidStartVpnArgs', () {
    test('includes socks host/port always', () {
      final args = androidStartVpnArgs(
        socksHost: '127.0.0.1',
        socksPort: 10808,
      );
      expect(args['socksHost'], '127.0.0.1');
      expect(args['socksPort'], 10808);
      expect(args.containsKey('socksUsername'), isFalse);
    });

    test('passes socks username/password', () {
      final args = androidStartVpnArgs(
        socksHost: '127.0.0.1',
        socksPort: 10808,
        socksUsername: 'gw',
        socksPassword: 's3cret',
      );
      expect(args['socksUsername'], 'gw');
      expect(args['socksPassword'], 's3cret');
    });

    test('passes disallowedPackages for per-app split', () {
      final args = androidStartVpnArgs(
        socksHost: '127.0.0.1',
        socksPort: 10808,
        disallowedPackages: const [
          'ru.sberbankmobile',
          ' ',
          'com.wise.androidclient',
        ],
      );
      expect(args['disallowedPackages'], [
        'ru.sberbankmobile',
        'com.wise.androidclient',
      ]);
    });

    test('passes bypassHost and excludeRoutes (no silent drop)', () {
      final args = androidStartVpnArgs(
        socksHost: '10.0.0.1',
        socksPort: 1080,
        bypassHost: ' 203.0.113.1 ',
        excludeRoutes: const ['10.0.0.0/8', ' 192.168.0.0/16 ', ''],
        dnsServers: const ['9.9.9.9', ''],
      );
      expect(args['bypassHost'], '203.0.113.1');
      expect(args['excludeRoutes'], ['10.0.0.0/8', '192.168.0.0/16']);
      expect(args['dnsServers'], ['9.9.9.9']);
    });
  });
}
