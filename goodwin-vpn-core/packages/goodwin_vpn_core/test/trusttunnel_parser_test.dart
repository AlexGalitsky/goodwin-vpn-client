import 'dart:convert';
import 'dart:typed_data';

import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';
import 'package:test/test.dart';

void main() {
  const parser = ShareLinkParser();

  group('trusttunnel TLV', () {
    test('parses minimal spec v1 payload', () {
      final bytes = BytesBuilder();
      void putTag(int tag, List<int> value) {
        bytes.addByte(tag); // single-byte varint (prefix 00)
        bytes.addByte(value.length);
        bytes.add(value);
      }

      putTag(0x00, [0x01]); // version 1
      putTag(0x01, utf8.encode('vpn.example.com'));
      putTag(0x02, utf8.encode('203.0.113.10:443'));
      putTag(0x05, utf8.encode('user'));
      putTag(0x06, utf8.encode('pass'));
      putTag(0x09, [0x01]); // http2
      putTag(0x0C, utf8.encode('MyTT'));

      final b64 = base64Url.encode(bytes.toBytes()).replaceAll('=', '');
      final link = 'tt://?$b64';
      final t = parser.parse(link) as TrustTunnelProfile;
      expect(t.name, 'MyTT');
      expect(t.hostname, 'vpn.example.com');
      expect(t.addresses, ['203.0.113.10:443']);
      expect(t.endpoint, '203.0.113.10:443');
      expect(t.username, 'user');
      expect(t.password, 'pass');
      expect(t.upstreamProtocol, 'http2');
      expect(t.deepLinkVersion, 1);
      expect(t.rawDeepLink, link);
    });

    test('legacy host form still parses', () {
      const link = 'tt://endpoint.example:443#TT';
      final t = parser.parse(link) as TrustTunnelProfile;
      expect(t.endpoint, 'endpoint.example:443');
      expect(t.name, 'TT');
      expect(t.hostname, isNull);
      expect(t.username, isNull);
    });
  });
}
