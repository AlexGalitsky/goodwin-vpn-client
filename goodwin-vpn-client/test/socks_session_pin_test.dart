import 'package:flutter_test/flutter_test.dart';
import 'package:goodwin_vpn_client/session/socks_session.dart';

void main() {
  test('literal IPv4 is a tunnel pin', () async {
    expect(await SocksSession.resolveTunnelPins('203.0.113.1'), ['203.0.113.1']);
  });

  test('literal IPv6 is a tunnel pin', () async {
    expect(await SocksSession.resolveTunnelPins('2001:db8::1'), ['2001:db8::1']);
  });

  test('dial pin prefers IPv4 when both families exist', () {
    expect(
      SocksSession.selectDialPin(['203.0.113.1', '2001:db8::1']),
      '203.0.113.1',
    );
    expect(SocksSession.selectDialPin(['2001:db8::1']), '2001:db8::1');
    expect(SocksSession.isIpv6Only(['2001:db8::1']), isTrue);
    expect(SocksSession.isIpv6Only(['203.0.113.1', '2001:db8::1']), isFalse);
    expect(SocksSession.pinCidr('2001:db8::1'), '2001:db8::1/128');
    expect(SocksSession.pinCidr('203.0.113.1'), '203.0.113.1/32');
  });

  test('empty host is not a pin', () async {
    expect(await SocksSession.resolveTunnelPins(''), isEmpty);
  });

  test('unknown host has no pins', () async {
    final pins = await SocksSession.resolveTunnelPins('no-such-host.invalid');
    expect(pins, isEmpty);
  });
}
