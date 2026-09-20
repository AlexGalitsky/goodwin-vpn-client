import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/session/goodwin_service.dart';

void main() {
  final sub = Uri.parse('https://saturn.goodwin.website/sub/token');

  test('parses v1 quoted base on the same host', () {
    final got = parseGoodwinVpnHeader(
      'v1; base="https://saturn.goodwin.website"',
      subscriptionUrl: sub,
    );
    expect(got?.protocolVersion, 1);
    expect(got?.serviceBase, 'https://saturn.goodwin.website');
  });

  test('accepts unquoted base and mixed header case via detect', () {
    final got = detectGoodwinService(
      headers: {
        'Goodwin-VPN': 'v1;base=https://saturn.goodwin.website',
      },
      subscriptionUrl: sub,
    );
    expect(got?.serviceBase, 'https://saturn.goodwin.website');
  });

  test('strips a path on base and still matches origin', () {
    final got = parseGoodwinVpnHeader(
      'v1; base="https://saturn.goodwin.website/gw/v1"',
      subscriptionUrl: sub,
    );
    expect(got?.serviceBase, 'https://saturn.goodwin.website');
  });

  test('matches explicit default https port with omitted port', () {
    final got = parseGoodwinVpnHeader(
      'v1; base="https://saturn.goodwin.website:443"',
      subscriptionUrl: sub,
    );
    expect(got?.serviceBase, 'https://saturn.goodwin.website');
  });

  test('keeps a non-default port on both sides', () {
    final got = parseGoodwinVpnHeader(
      'v1; base="https://example.com:8443"',
      subscriptionUrl: Uri.parse('https://example.com:8443/sub/x'),
    );
    expect(got?.serviceBase, 'https://example.com:8443');
  });

  test('rejects http base, other host, v2, and userinfo', () {
    expect(
      parseGoodwinVpnHeader(
        'v1; base="http://saturn.goodwin.website"',
        subscriptionUrl: sub,
      ),
      isNull,
    );
    expect(
      parseGoodwinVpnHeader(
        'v1; base="https://evil.example"',
        subscriptionUrl: sub,
      ),
      isNull,
    );
    expect(
      parseGoodwinVpnHeader(
        'v2; base="https://saturn.goodwin.website"',
        subscriptionUrl: sub,
      ),
      isNull,
    );
    expect(
      parseGoodwinVpnHeader(
        'v1; base="https://user:pass@saturn.goodwin.website"',
        subscriptionUrl: sub,
      ),
      isNull,
    );
    expect(parseGoodwinVpnHeader('', subscriptionUrl: sub), isNull);
    expect(parseGoodwinVpnHeader('not-a-header', subscriptionUrl: sub), isNull);
    expect(
      detectGoodwinService(headers: {}, subscriptionUrl: sub),
      isNull,
    );
  });

  test('parses GET /gw/v1/service and ignores a foreign privacy host', () {
    const base = 'https://saturn.goodwin.website';
    final got = parseGoodwinServiceCatalog(
      '''
{
  "protocol": "goodwin-vpn",
  "version": 1,
  "name": "Goodwin VPN",
  "privacy": "/privacy",
  "support": "https://saturn.goodwin.website/support",
  "features": ["geo-packs", "billing-never", 3, ""]
}
''',
      serviceBase: base,
    );
    expect(got?.name, 'Goodwin VPN');
    expect(got?.privacyUrl, 'https://saturn.goodwin.website/privacy');
    expect(got?.supportUrl, 'https://saturn.goodwin.website/support');
    expect(got?.features, ['geo-packs', 'billing-never']);
    expect(got?.hasFeature(kGoodwinFeatureGeoPacks), isTrue);

    expect(
      parseGoodwinServiceCatalog(
        '{"protocol":"goodwin-vpn","version":1,"privacy":"https://evil.example/privacy"}',
        serviceBase: base,
      )?.privacyUrl,
      isNull,
    );
    expect(
      parseGoodwinServiceCatalog(
        '{"protocol":"goodwin-vpn","version":1,"privacy":"http://saturn.goodwin.website/privacy"}',
        serviceBase: base,
      )?.privacyUrl,
      isNull,
    );
    expect(
      parseGoodwinServiceCatalog('{"name":"x"}', serviceBase: base),
      isNull,
    );
    expect(
      parseGoodwinServiceCatalog(
        '{"protocol":"goodwin-vpn","version":2,"name":"x"}',
        serviceBase: base,
      ),
      isNull,
    );
  });
}
