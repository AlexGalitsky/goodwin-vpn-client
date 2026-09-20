import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/features/routing/domain/geo_pack.dart';
import 'package:goodwin_vpn_client/features/routing/domain/models/routing_models.dart';
import 'package:goodwin_vpn_client/session/goodwin_geo.dart';
import 'package:goodwin_vpn_client/session/goodwin_geo_cache.dart';
import 'package:goodwin_vpn_client/session/goodwin_geo_prefetch.dart';

import 'support/fakes.dart';

void main() {
  const origin = 'https://panel.example';

  test('parses manifest and rejects a foreign pack URL', () {
    final sha = 'a' * 64;
    final got = parseGeoManifest(
      jsonEncode({
        'version': '2026.09.12',
        'packs': [
          {
            'id': 'ads',
            'url': '/gw/v1/geo/packs/ads',
            'sha256': sha,
            'bytes': 12,
          },
        ],
      }),
      serviceBase: origin,
    );
    expect(got?.version, '2026.09.12');
    expect(got?.pack('ads')?.url, 'https://panel.example/gw/v1/geo/packs/ads');

    expect(
      parseGeoManifest(
        jsonEncode({
          'version': '1',
          'packs': [
            {
              'id': 'ads',
              'url': 'https://evil.example/gw/v1/geo/packs/ads',
              'sha256': sha,
              'bytes': 12,
            },
          ],
        }),
        serviceBase: origin,
      ),
      isNull,
    );
  });

  test('pack JSON expands suffixes; sha256 must match exact bytes', () {
    const raw =
        '{"id":"ads","domains":["tracker.example"],"suffixes":[".doubleclick.net"],"cidrs":[]}';
    final body = utf8.encode(raw);
    final pack = parseGeoPack(raw);
    expect(pack?.id, 'ads');
    expect(pack?.expand(RoutingAction.block), isNotEmpty);
    expect(
      pack!
          .expand(RoutingAction.block)
          .any((e) => e.matcher.value == 'doubleclick.net'),
      isTrue,
    );

    final meta = GeoPackMeta(
      id: 'ads',
      url: 'https://panel.example/gw/v1/geo/packs/ads',
      sha256: sha256Hex(body),
      bytes: body.length,
    );
    expect(packBytesMatchMeta(body, meta), isTrue);
    expect(packBytesMatchMeta(utf8.encode('$raw '), meta), isFalse);
  });

  test('prefetch writes ads when sha256 matches; skips a bad hash', () async {
    const raw =
        '{"id":"ads","domains":[],"suffixes":[".doubleclick.net"],"cidrs":[]}';
    final body = Uint8List.fromList(utf8.encode(raw));
    final meta = GeoPackMeta(
      id: 'ads',
      url: 'https://panel.example/gw/v1/geo/packs/ads',
      sha256: sha256Hex(body),
      bytes: body.length,
    );
    final cache = MemoryGeoPackCache();
    final client = FakeGoodwinGeoClient(
      manifest: GeoManifest(version: '2026.09.12', packs: [meta]),
      packBytes: body,
    );
    await GoodwinGeoPrefetcher(client: client, cache: cache).prefetch(origin);
    final ads = await cache.readAds(origin);
    expect(ads, isA<GeoPack>());
    expect(ads!.suffixes, contains('.doubleclick.net'));
    expect(client.packCount, 1);

    await GoodwinGeoPrefetcher(client: client, cache: cache).prefetch(origin);
    expect(client.packCount, 1);

    final bad = FakeGoodwinGeoClient(
      manifest: GeoManifest(
        version: 'x',
        packs: [
          GeoPackMeta(
            id: 'ads',
            url: meta.url,
            sha256: 'b' * 64,
            bytes: body.length,
          ),
        ],
      ),
      packBytes: body,
    );
    final empty = MemoryGeoPackCache();
    await GoodwinGeoPrefetcher(client: bad, cache: empty).prefetch(origin);
    expect(await empty.readAds(origin), isNull);
  });
}
