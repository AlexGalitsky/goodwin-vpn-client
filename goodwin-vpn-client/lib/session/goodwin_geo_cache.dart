import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../features/routing/domain/geo_pack.dart';
import 'goodwin_geo.dart';
import 'goodwin_service.dart';

abstract class GeoPackCache {
  Future<GeoPack?> readAds(String serviceBase);

  Future<bool> matches({
    required String serviceBase,
    required String id,
    required String sha256,
  });

  Future<void> write({
    required String serviceBase,
    required String id,
    required String sha256,
    required List<int> body,
  });
}

class MemoryGeoPackCache implements GeoPackCache {
  final _body = <String, List<int>>{};
  final _sha = <String, String>{};

  @override
  Future<GeoPack?> readAds(String serviceBase) async {
    final origin = httpsOrigin(Uri.tryParse(serviceBase.trim()) ?? Uri());
    if (origin == null) return null;
    final key = _cacheKey(origin, kGoodwinGeoPackAdsId);
    final body = _body[key];
    if (body == null) return null;
    return parseGeoPack(utf8.decode(body, allowMalformed: true));
  }

  @override
  Future<bool> matches({
    required String serviceBase,
    required String id,
    required String sha256,
  }) async {
    final origin = httpsOrigin(Uri.tryParse(serviceBase.trim()) ?? Uri());
    if (origin == null) return false;
    return _sha[_cacheKey(origin, id)] == sha256.toLowerCase();
  }

  @override
  Future<void> write({
    required String serviceBase,
    required String id,
    required String sha256,
    required List<int> body,
  }) async {
    final origin = httpsOrigin(Uri.tryParse(serviceBase.trim()) ?? Uri());
    if (origin == null) return;
    final key = _cacheKey(origin, id);
    _body[key] = List<int>.from(body);
    _sha[key] = sha256.toLowerCase();
  }
}

class PrefsGeoPackCache implements GeoPackCache {
  PrefsGeoPackCache(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<GeoPack?> readAds(String serviceBase) async {
    final origin = httpsOrigin(Uri.tryParse(serviceBase.trim()) ?? Uri());
    if (origin == null) return null;
    final key = _cacheKey(origin, kGoodwinGeoPackAdsId);
    final raw = _prefs.getString('$key.body');
    final sha = _prefs.getString('$key.sha256');
    if (raw == null || sha == null) return null;
    final body = utf8.encode(raw);
    if (sha256Hex(body) != sha) return null;
    return parseGeoPack(raw);
  }

  @override
  Future<bool> matches({
    required String serviceBase,
    required String id,
    required String sha256,
  }) async {
    final origin = httpsOrigin(Uri.tryParse(serviceBase.trim()) ?? Uri());
    if (origin == null) return false;
    final key = _cacheKey(origin, id);
    return _prefs.getString('$key.sha256') == sha256.toLowerCase();
  }

  @override
  Future<void> write({
    required String serviceBase,
    required String id,
    required String sha256,
    required List<int> body,
  }) async {
    final origin = httpsOrigin(Uri.tryParse(serviceBase.trim()) ?? Uri());
    if (origin == null) return;
    final key = _cacheKey(origin, id);
    await _prefs.setString('$key.body', utf8.decode(body));
    await _prefs.setString('$key.sha256', sha256.toLowerCase());
  }
}

String _cacheKey(String origin, String id) {
  final host = sha256Hex(utf8.encode(origin.toLowerCase())).substring(0, 16);
  return 'geo.pack.v1.$host.$id';
}
