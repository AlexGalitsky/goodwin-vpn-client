import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/features/connection/domain/node_endpoint.dart';
import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';

void main() {
  test('parses vless host and port', () {
    const link =
        'vless://11111111-2222-3333-4444-555555555555@example.com:8443';
    final endpoint = endpointForShareLink(link);
    expect(endpoint?.host, 'example.com');
    expect(endpoint?.port, 8443);
  });

  test('parses trusttunnel endpoint host:port', () {
    final profile = const ShareLinkParser().parse('tt://edge.example:443#TT');
    final endpoint = endpointForProfile(profile);
    expect(endpoint?.host, 'edge.example');
    expect(endpoint?.port, 443);
  });

  test('parseHostPort supports ipv6 brackets', () {
    final endpoint = parseHostPort('[2001:db8::1]:8443');
    expect(endpoint?.host, '2001:db8::1');
    expect(endpoint?.port, 8443);
  });

  test('parseHostPort defaults bare host to 443', () {
    final endpoint = parseHostPort('vpn.example');
    expect(endpoint?.host, 'vpn.example');
    expect(endpoint?.port, 443);
  });

  test('bad share link has no endpoint', () {
    expect(endpointForShareLink('not-a-link'), isNull);
  });
}
