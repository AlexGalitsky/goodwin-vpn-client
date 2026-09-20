import 'dart:convert';

import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';
import 'package:test/test.dart';

void main() {
  const parser = ShareLinkParser();

  group('vless', () {
    test('parses reality+grpc link', () {
      const link =
          'vless://11111111-2222-3333-4444-555555555555@example.com:8443'
          '?encryption=none&type=grpc&serviceName=svc&mode=gun'
          '&security=reality&sni=www.cloudflare.com&fp=chrome'
          '&pbk=PUBLICKEY&sid=abcd1234#TestNode';

      final profile = parser.parse(link);
      expect(profile, isA<XrayProfile>());
      final x = profile as XrayProfile;
      expect(x.protocol, XrayProtocol.vless);
      expect(x.name, 'TestNode');
      expect(x.address, 'example.com');
      expect(x.port, 8443);
      expect(x.id, '11111111-2222-3333-4444-555555555555');
      expect(x.network, 'grpc');
      expect(x.security, 'reality');
      expect(x.sni, 'www.cloudflare.com');
      expect(x.fingerprint, 'chrome');
      expect(x.publicKey, 'PUBLICKEY');
      expect(x.shortId, 'abcd1234');
      expect(x.serviceName, 'svc');
      expect(x.grpcMode, 'gun');
    });
  });

  group('vmess', () {
    test('parses base64 json share link', () {
      final payload = base64.encode(
        utf8.encode(
          jsonEncode({
            'v': '2',
            'ps': 'VMessNode',
            'add': '1.2.3.4',
            'port': '443',
            'id': 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee',
            'aid': '0',
            'scy': 'auto',
            'net': 'ws',
            'type': 'none',
            'host': 'cdn.example.com',
            'path': '/ray',
            'tls': 'tls',
            'sni': 'cdn.example.com',
            'fp': 'chrome',
          }),
        ),
      );
      final profile = parser.parse('vmess://$payload');
      final x = profile as XrayProfile;
      expect(x.protocol, XrayProtocol.vmess);
      expect(x.name, 'VMessNode');
      expect(x.address, '1.2.3.4');
      expect(x.port, 443);
      expect(x.network, 'ws');
      expect(x.security, 'tls');
      expect(x.wsPath, '/ray');
      expect(x.wsHost, 'cdn.example.com');
    });
  });

  group('trojan', () {
    test('parses tls trojan link', () {
      const link =
          'trojan://s3cret@trojan.example:443?security=tls&sni=trojan.example&type=tcp#Trojan';
      final x = parser.parse(link) as XrayProfile;
      expect(x.protocol, XrayProtocol.trojan);
      expect(x.id, 's3cret');
      expect(x.address, 'trojan.example');
      expect(x.port, 443);
      expect(x.security, 'tls');
      expect(x.sni, 'trojan.example');
      expect(x.name, 'Trojan');
    });
  });

  group('hysteria2', () {
    test('parses hy2 alias', () {
      const link = 'hy2://pw@hy.example:443/?sni=hy.example&insecure=0#Hy';
      final h = parser.parse(link) as HysteriaProfile;
      expect(h.password, 'pw');
      expect(h.address, 'hy.example');
      expect(h.port, 443);
      expect(h.sni, 'hy.example');
      expect(h.insecure, isFalse);
      expect(h.name, 'Hy');
    });
  });

  group('trusttunnel', () {
    test('captures tt deep link', () {
      const link = 'tt://endpoint.example:443#TT';
      final t = parser.parse(link) as TrustTunnelProfile;
      expect(t.endpoint, 'endpoint.example:443');
      expect(t.name, 'TT');
      expect(t.rawDeepLink, link);
    });
  });

  group('errors', () {
    test('rejects empty and unknown schemes', () {
      expect(() => parser.parse(''), throwsA(isA<ShareLinkParseException>()));
      expect(() => parser.parse('ftp://x'), throwsA(isA<ShareLinkParseException>()));
    });

    test('rejects ss:// with clear message', () {
      expect(
        () => parser.parse('ss://YWVzLTI1Ni1nY206cGFzcw@host:8388'),
        throwsA(
          isA<ShareLinkParseException>().having(
            (e) => e.message,
            'message',
            contains('Shadowsocks'),
          ),
        ),
      );
    });

    test('rejects hysteria2 with obfs', () {
      expect(
        () => parser.parse(
          'hy2://pw@hy.example:443/?sni=hy.example&obfs=salamander#Hy',
        ),
        throwsA(
          isA<ShareLinkParseException>().having(
            (e) => e.message,
            'message',
            contains('obfs'),
          ),
        ),
      );
    });

    test('rejects unsupported Xray network at parse', () {
      expect(
        () => parser.parse(
          'vless://11111111-2222-3333-4444-555555555555@example.com:443'
          '?encryption=none&type=httpupgrade&security=tls#Bad',
        ),
        throwsA(
          isA<ShareLinkParseException>().having(
            (e) => e.message,
            'message',
            contains('unsupported Xray network'),
          ),
        ),
      );
    });
  });

  group('toString redacts secrets', () {
    test('vless UUID is not in toString', () {
      const uuid = '11111111-2222-3333-4444-555555555555';
      final profile = parser.parse(
        'vless://$uuid@example.com:8443'
        '?encryption=none&security=none#TestNode',
      );
      expect(profile.toString(), isNot(contains(uuid)));
      expect(parser.describe(profile), isNot(contains(uuid)));
    });

    test('hysteria password is not in toString', () {
      final profile = parser.parse('hy2://super-secret@hy.example:443/?sni=hy.example#Hy');
      expect(profile.toString(), isNot(contains('super-secret')));
      expect(parser.describe(profile), isNot(contains('super-secret')));
    });
  });
}
