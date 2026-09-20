import 'dart:convert';

const kGoodwinProtocol = 'goodwin-vpn';
const kGoodwinServicePath = '/gw/v1/service';
const kGoodwinFeatureGeoPacks = 'geo-packs';
const kGoodwinFeatureJsonProfile = 'json-profile';

/// Detected Goodwin control-plane origin from `Goodwin-VPN` on `/sub`.
class GoodwinServiceRef {
  const GoodwinServiceRef({
    required this.protocolVersion,
    required this.serviceBase,
  });

  final int protocolVersion;

  /// HTTPS origin, no path, e.g. `https://saturn.goodwin.website`.
  final String serviceBase;
}

/// Catalog from `GET {base}/gw/v1/service`.
class GoodwinServiceCatalog {
  const GoodwinServiceCatalog({
    required this.version,
    this.name,
    this.privacyUrl,
    this.supportUrl,
    this.features = const [],
  });

  final int version;
  final String? name;
  final String? privacyUrl;
  final String? supportUrl;
  final List<String> features;

  bool hasFeature(String id) => features.contains(id);
}

String? headerIgnoreCase(Map<String, String> headers, String name) {
  final want = name.toLowerCase();
  for (final entry in headers.entries) {
    if (entry.key.toLowerCase() != want) continue;
    final v = entry.value.trim();
    if (v.isNotEmpty) return v;
  }
  return null;
}

/// Parse `Goodwin-VPN: v1; base="https://example.com"`.
///
/// Unknown / http / other-host values are ignored (generic subscription).
GoodwinServiceRef? parseGoodwinVpnHeader(
  String? raw, {
  required Uri subscriptionUrl,
}) {
  if (raw == null) return null;
  final chunks = raw
      .split(';')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();
  if (chunks.isEmpty) return null;

  final ver = RegExp(r'^v(\d+)$', caseSensitive: false).firstMatch(chunks.first);
  if (ver == null) return null;
  final version = int.tryParse(ver.group(1)!);
  if (version == null || version != 1) return null;

  String? baseRaw;
  for (final chunk in chunks.skip(1)) {
    final eq = chunk.indexOf('=');
    if (eq <= 0) continue;
    if (chunk.substring(0, eq).trim().toLowerCase() != 'base') continue;
    var v = chunk.substring(eq + 1).trim();
    if (v.length >= 2 &&
        ((v.startsWith('"') && v.endsWith('"')) ||
            (v.startsWith("'") && v.endsWith("'")))) {
      v = v.substring(1, v.length - 1);
    }
    baseRaw = v.trim();
    break;
  }
  if (baseRaw == null || baseRaw.isEmpty) return null;

  final base = Uri.tryParse(baseRaw);
  if (base == null || base.userInfo.isNotEmpty) return null;
  final origin = httpsOrigin(base);
  if (origin == null) return null;
  if (!_sameHttpsOrigin(origin, subscriptionUrl)) return null;
  return GoodwinServiceRef(protocolVersion: version, serviceBase: origin);
}

GoodwinServiceRef? detectGoodwinService({
  required Map<String, String> headers,
  required Uri subscriptionUrl,
}) {
  return parseGoodwinVpnHeader(
    headerIgnoreCase(headers, 'goodwin-vpn'),
    subscriptionUrl: subscriptionUrl,
  );
}

/// HTTPS origin without path/query, or null.
String? httpsOrigin(Uri uri) {
  if (uri.scheme.toLowerCase() != 'https' || uri.host.isEmpty) return null;
  if (uri.hasPort && uri.port != 443) {
    return Uri(scheme: 'https', host: uri.host, port: uri.port).origin;
  }
  return Uri(scheme: 'https', host: uri.host).origin;
}

bool _sameHttpsOrigin(String baseOrigin, Uri subscriptionUrl) {
  final sub = httpsOrigin(subscriptionUrl);
  if (sub == null) return false;
  return baseOrigin.toLowerCase() == sub.toLowerCase();
}

/// Parse `GET /gw/v1/service` JSON. Unknown keys/features are ignored.
GoodwinServiceCatalog? parseGoodwinServiceCatalog(
  String raw, {
  required String serviceBase,
}) {
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
  if (json['protocol'] != kGoodwinProtocol) return null;
  final version = (json['version'] as num?)?.toInt();
  if (version == null || version != 1) return null;

  final name = _boundedString(json['name'], 200);
  final privacy = sameOriginHttpsUrl(json['privacy'], origin);
  final support = sameOriginHttpsUrl(json['support'], origin);
  final features = <String>[];
  final rawFeatures = json['features'];
  if (rawFeatures is List) {
    for (final item in rawFeatures) {
      if (item is! String) continue;
      final id = item.trim();
      if (id.isEmpty || id.length > 64) continue;
      if (!features.contains(id)) features.add(id);
      if (features.length >= 32) break;
    }
  }
  return GoodwinServiceCatalog(
    version: version,
    name: name,
    privacyUrl: privacy,
    supportUrl: support,
    features: List<String>.unmodifiable(features),
  );
}

String? sameOriginHttpsUrl(Object? raw, String serviceBase) {
  if (raw is! String) return null;
  final origin = httpsOrigin(Uri.tryParse(serviceBase) ?? Uri());
  if (origin == null) return null;
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return null;
  final base = Uri.parse(origin);
  final parsed = Uri.tryParse(trimmed);
  if (parsed == null || parsed.userInfo.isNotEmpty) return null;
  final resolved = parsed.hasScheme ? parsed : base.resolveUri(parsed);
  final resolvedOrigin = httpsOrigin(resolved);
  if (resolvedOrigin == null) return null;
  if (resolvedOrigin.toLowerCase() != origin.toLowerCase()) return null;
  final href = resolved.toString();
  final hash = href.indexOf('#');
  return hash < 0 ? href : href.substring(0, hash);
}

String? _boundedString(Object? raw, int max) {
  if (raw is! String) return null;
  final t = raw.trim();
  if (t.isEmpty) return null;
  return t.length <= max ? t : t.substring(0, max);
}
