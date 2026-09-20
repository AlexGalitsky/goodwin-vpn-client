import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/core/config/dns_mode.dart';
import 'package:goodwin_vpn_client/core/config/tun_dns.dart';

void main() {
  group('tunDnsServersFromSettings', () {
    test('system → defaults', () {
      expect(
        tunDnsServersFromSettings(mode: DnsMode.system, custom: null),
        kDefaultTunDnsServers,
      );
    });

    test('custom keeps IPs and drops DoH URLs', () {
      expect(
        tunDnsServersFromSettings(
          mode: DnsMode.custom,
          custom: '1.1.1.1, https://dns.google/dns-query, 8.8.8.8',
        ),
        ['1.1.1.1', '8.8.8.8'],
      );
    });

    test('doh without IPs → bootstrap defaults', () {
      expect(
        tunDnsServersFromSettings(
          mode: DnsMode.doh,
          custom: 'https://cloudflare-dns.com/dns-query',
        ),
        kDefaultTunDnsServers,
      );
    });
  });
}
