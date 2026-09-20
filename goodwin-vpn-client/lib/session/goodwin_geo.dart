import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';

import '../features/routing/domain/geo_pack.dart';
import 'goodwin_service.dart';

const kGoodwinGeoManifestPath = '/gw/v1/geo/manifest';
const kGoodwinGeoPackAdsId = 'ads';
const kGoodwinGeoManifestMaxBytes = 64 * 1024;
const kGoodwinGeoPackMaxBytes = 512 * 1024;

class GeoPackMeta {
  const GeoPackMeta({
    required this.id,
    required this.url,
    required this.sha256,
    required this.bytes,
  });

  final String id;
  final String url;
  final String sha256;
  final int bytes;
}

class GeoManifest {
  const GeoManifest({required this.version, required this.packs});

  final String version;
  final List<GeoPackMeta> packs;

  GeoPackMeta? pack(String id) {
    for (final pack in packs) {
      if (pack.id == id) return pack;
    }
    return null;
  }
}

String sha256Hex(List<int> bytes) {
  final digest = SHA256Digest().process(Uint8List.fromList(bytes));
  final out = StringBuffer();
  for (final b in digest) {
    out.write(b.toRadixString(16).padLeft(2, '0'));
  }
  return out.toString();
}

/// Parse `GET /gw/v1/geo/manifest`. Pack URLs must be same-origin HTTPS.
GeoManifest? parseGeoManifest(String raw, {required String serviceBase}) {
  final origin = httpsOrigin(Uri.tryParse(serviceBase.trim()) ?? Uri());
  if (origin == null) return null;
  Object? decoded;
  try {
    decoded = jsonDecode(raw);
  } catch (_) {
    return null;
  }
  if (decoded is! Map) return null;
  final json = Map<String, dynamic>.from(decoded);
  final version = _boundedString(json['version'], 64);
  if (version == null) return null;
  final rawPacks = json['packs'];
  if (rawPacks is! List) return null;
  final packs = <GeoPackMeta>[];
  for (final item in rawPacks) {
    if (item is! Map) continue;
    final row = Map<String, dynamic>.from(item);
    final id = _packId(row['id']);
    if (id == null) continue;
    final href = sameOriginHttpsUrl(row['url'], origin);
    if (href == null) continue;
    final sha = _sha256Hex(row['sha256']);
    if (sha == null) continue;
    final bytes = (row['bytes'] as num?)?.toInt();
    if (bytes == null || bytes < 1 || bytes > kGoodwinGeoPackMaxBytes) {
      continue;
    }
    if (packs.any((p) => p.id == id)) continue;
    packs.add(GeoPackMeta(id: id, url: href, sha256: sha, bytes: bytes));
    if (packs.length >= 16) break;
  }
  if (packs.isEmpty) return null;
  return GeoManifest(version: version, packs: List.unmodifiable(packs));
}

/// Parse pack JSON. Invalid matchers are dropped; empty pack is rejected.
GeoPack? parseGeoPack(String raw) {
  Object? decoded;
  try {
    decoded = jsonDecode(raw);
  } catch (_) {
    return null;
  }
  if (decoded is! Map) return null;
  final json = Map<String, dynamic>.from(decoded);
  final id = _packId(json['id']);
  if (id == null) return null;
  final domains = _stringList(json['domains'], max: 2000);
  final suffixes = _stringList(json['suffixes'], max: 2000);
  final cidrs = _stringList(json['cidrs'], max: 2000);
  if (domains.length + suffixes.length + cidrs.length > 2000) return null;
  final pack = GeoPack(
    id: id,
    domains: domains,
    suffixes: suffixes,
    cidrs: cidrs,
  );
  if (pack.matcherCount == 0) return null;
  return pack;
}

bool packBytesMatchMeta(List<int> body, GeoPackMeta meta) {
  if (body.length != meta.bytes) return false;
  return sha256Hex(body) == meta.sha256;
}

String? _packId(Object? raw) {
  if (raw is! String) return null;
  final id = raw.trim();
  if (id.isEmpty || id.length > 32) return null;
  if (!RegExp(r'^[a-z][a-z0-9-]*$').hasMatch(id)) return null;
  return id;
}

String? _sha256Hex(Object? raw) {
  if (raw is! String) return null;
  final hex = raw.trim().toLowerCase();
  if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(hex)) return null;
  return hex;
}

String? _boundedString(Object? raw, int max) {
  if (raw is! String) return null;
  final t = raw.trim();
  if (t.isEmpty) return null;
  return t.length <= max ? t : t.substring(0, max);
}

List<String> _stringList(Object? raw, {required int max}) {
  if (raw is! List) return const [];
  final out = <String>[];
  for (final item in raw) {
    if (item is! String) continue;
    final t = item.trim();
    if (t.isEmpty || t.length > 256) continue;
    if (!out.contains(t)) out.add(t);
    if (out.length >= max) break;
  }
  return List<String>.unmodifiable(out);
}
