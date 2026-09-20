import 'dart:convert';

import 'goodwin_geo.dart';
import 'goodwin_geo_cache.dart';
import 'goodwin_geo_client.dart';
import 'goodwin_service.dart';

/// Best-effort download of the `ads` pack. Never throws to callers.
class GoodwinGeoPrefetcher {
  GoodwinGeoPrefetcher({
    required GoodwinGeoClient client,
    required GeoPackCache cache,
  }) : _client = client,
       _cache = cache;

  final GoodwinGeoClient _client;
  final GeoPackCache _cache;

  Future<void> prefetch(String serviceBase) async {
    final origin = httpsOrigin(Uri.tryParse(serviceBase.trim()) ?? Uri());
    if (origin == null) return;
    try {
      final manifest = await _client.fetchManifest(origin);
      final ads = manifest?.pack(kGoodwinGeoPackAdsId);
      if (ads == null) return;
      if (await _cache.matches(
        serviceBase: origin,
        id: ads.id,
        sha256: ads.sha256,
      )) {
        return;
      }
      final body = await _client.fetchPackBytes(serviceBase: origin, meta: ads);
      if (body == null || !packBytesMatchMeta(body, ads)) return;
      final pack = parseGeoPack(utf8.decode(body));
      if (pack == null || pack.id != kGoodwinGeoPackAdsId) return;
      await _cache.write(
        serviceBase: origin,
        id: ads.id,
        sha256: ads.sha256,
        body: body,
      );
    } catch (_) {}
  }
}
