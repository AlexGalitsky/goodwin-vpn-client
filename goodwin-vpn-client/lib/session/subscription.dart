import 'dart:convert';

import 'goodwin_service.dart';
import 'saved_profile.dart';

class SubscriptionUserinfo {
  const SubscriptionUserinfo({
    this.upload = 0,
    this.download = 0,
    this.total = 0,
    this.expire,
    this.deviceLimit,
    this.deviceCount,
  });

  final int upload;
  final int download;
  final int total;
  final DateTime? expire;

  /// Max concurrent devices from the panel (`device-limit=`). Null = not advertised.
  final int? deviceLimit;

  /// Current devices/sessions from the panel (`device-count=` / `devices=`).
  /// Null when the panel does not report it — never invent a count client-side.
  final int? deviceCount;

  int get used => upload + download;

  bool get hasQuota => total > 0;

  bool get hasDeviceInfo =>
      (deviceLimit != null && deviceLimit! > 0) ||
      (deviceCount != null && deviceCount! >= 0);

  Map<String, dynamic> toJson() => {
    'upload': upload,
    'download': download,
    'total': total,
    if (expire != null) 'expire': expire!.millisecondsSinceEpoch ~/ 1000,
    if (deviceLimit != null && deviceLimit! > 0) 'deviceLimit': deviceLimit,
    if (deviceCount != null && deviceCount! >= 0) 'deviceCount': deviceCount,
  };

  static SubscriptionUserinfo? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final expireRaw = json['expire'];
    DateTime? expire;
    if (expireRaw is int && expireRaw > 0) {
      expire = DateTime.fromMillisecondsSinceEpoch(
        expireRaw * 1000,
        isUtc: true,
      );
    }
    return SubscriptionUserinfo(
      upload: (json['upload'] as num?)?.toInt() ?? 0,
      download: (json['download'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      expire: expire,
      deviceLimit: _positiveInt(json['deviceLimit']),
      deviceCount: _nonNegInt(json['deviceCount']),
    );
  }

  /// `upload=0; download=1; total=2; expire=1790951622; device-limit=3; device-count=1`
  static SubscriptionUserinfo? parseHeader(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final parts = <String, String>{};
    for (final chunk in raw.split(';')) {
      final i = chunk.indexOf('=');
      if (i <= 0) continue;
      parts[chunk.substring(0, i).trim().toLowerCase()] = chunk
          .substring(i + 1)
          .trim();
    }
    if (parts.isEmpty) return null;
    final expireUnix = int.tryParse(parts['expire'] ?? '');
    final limit = _parseOptionalInt(
      parts['device-limit'] ??
          parts['device_limit'] ??
          parts['devicelimit'],
    );
    final count = _parseOptionalInt(
      parts['device-count'] ??
          parts['device_count'] ??
          parts['devicecount'] ??
          parts['devices'],
    );
    return SubscriptionUserinfo(
      upload: int.tryParse(parts['upload'] ?? '') ?? 0,
      download: int.tryParse(parts['download'] ?? '') ?? 0,
      total: int.tryParse(parts['total'] ?? '') ?? 0,
      expire: expireUnix != null && expireUnix > 0
          ? DateTime.fromMillisecondsSinceEpoch(expireUnix * 1000, isUtc: true)
          : null,
      deviceLimit: limit != null && limit > 0 ? limit : null,
      deviceCount: count != null && count >= 0 ? count : null,
    );
  }

  static int? _parseOptionalInt(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return int.tryParse(raw);
  }

  static int? _positiveInt(Object? raw) {
    if (raw is! num) return null;
    final n = raw.toInt();
    return n > 0 ? n : null;
  }

  static int? _nonNegInt(Object? raw) {
    if (raw is! num) return null;
    final n = raw.toInt();
    return n >= 0 ? n : null;
  }

  /// Plane counts Xray/VLESS only. Hy2 and TrustTunnel are not in these bytes.
  static const quotaScopeNote =
      'VLESS+Hy2 traffic — TrustTunnel uncounted';

  String get displayLine {
    final bits = <String>[];
    if (hasQuota) {
      bits.add('${fmtBytes(used)} / ${fmtBytes(total)} VLESS');
    } else if (used > 0) {
      bits.add('${fmtBytes(used)} used · VLESS');
    }
    if (expire != null) {
      final days = expire!.toUtc().difference(DateTime.now().toUtc()).inDays;
      if (days < 0) {
        bits.add('expired');
      } else {
        bits.add('${days}d left');
      }
    }
    return bits.join(' · ');
  }

  static String fmtBytes(int n) {
    if (n >= 1024 * 1024 * 1024) {
      return '${(n / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
    if (n >= 1024 * 1024) {
      return '${(n / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    if (n >= 1024) {
      return '${(n / 1024).toStringAsFixed(0)} KB';
    }
    return '$n B';
  }
}

class VpnSubscription {
  const VpnSubscription({
    required this.id,
    required this.name,
    required this.url,
    this.accountLabel,
    this.lastFetched,
    this.intervalHours = 24,
    this.userinfo,
    this.revoked = false,
    this.serviceBase,
    this.protocolVersion,
    this.serviceName,
    this.privacyUrl,
    this.supportUrl,
    this.features = const [],
  });

  final String id;

  /// Provider / panel display name (group title). Not the end-user account.
  final String name;
  final String url;

  /// Account label from `profile-title` (often username/email). Shown as secondary.
  final String? accountLabel;
  final DateTime? lastFetched;
  final int intervalHours;
  final SubscriptionUserinfo? userinfo;

  /// Panel returned 404 on this URL. Nodes stay until the user pastes a new link.
  final bool revoked;

  /// HTTPS origin from `Goodwin-VPN` (`base=`). Null = generic `/sub`.
  final String? serviceBase;

  /// Parsed `vN` from `Goodwin-VPN`. Null when [serviceBase] is null.
  final int? protocolVersion;

  /// Operator name from `GET /gw/v1/service` (`name`).
  final String? serviceName;

  /// HTTPS privacy URL from the service catalog, same origin as [serviceBase].
  final String? privacyUrl;

  final String? supportUrl;

  /// Feature ids from the last catalog fetch. Unknown ids are stored but unused.
  final List<String> features;

  bool get isGoodwinService =>
      serviceBase != null && serviceBase!.isNotEmpty && protocolVersion == 1;

  bool get isDue {
    if (lastFetched == null) return true;
    final hours = intervalHours <= 0 ? 24 : intervalHours;
    return DateTime.now().toUtc().difference(lastFetched!.toUtc()) >=
        Duration(hours: hours);
  }

  VpnSubscription copyWith({
    String? name,
    String? url,
    String? accountLabel,
    DateTime? lastFetched,
    int? intervalHours,
    SubscriptionUserinfo? userinfo,
    bool? revoked,
    String? serviceBase,
    int? protocolVersion,
    String? serviceName,
    String? privacyUrl,
    String? supportUrl,
    List<String>? features,
    bool clearUserinfo = false,
    bool clearLastFetched = false,
    bool clearAccountLabel = false,
    bool clearService = false,
  }) {
    return VpnSubscription(
      id: id,
      name: name ?? this.name,
      url: url ?? this.url,
      accountLabel: clearAccountLabel
          ? null
          : (accountLabel ?? this.accountLabel),
      lastFetched: clearLastFetched ? null : (lastFetched ?? this.lastFetched),
      intervalHours: intervalHours ?? this.intervalHours,
      userinfo: clearUserinfo ? null : (userinfo ?? this.userinfo),
      revoked: revoked ?? this.revoked,
      serviceBase: clearService ? null : (serviceBase ?? this.serviceBase),
      protocolVersion: clearService
          ? null
          : (protocolVersion ?? this.protocolVersion),
      serviceName: clearService ? null : (serviceName ?? this.serviceName),
      privacyUrl: clearService ? null : (privacyUrl ?? this.privacyUrl),
      supportUrl: clearService ? null : (supportUrl ?? this.supportUrl),
      features: clearService ? const [] : (features ?? this.features),
    );
  }

  /// Keep this catalog's fields but the existing store id (upsert-by-URL).
  VpnSubscription withId(String nextId) {
    if (nextId == id) return this;
    return VpnSubscription(
      id: nextId,
      name: name,
      url: url,
      accountLabel: accountLabel,
      lastFetched: lastFetched,
      intervalHours: intervalHours,
      userinfo: userinfo,
      revoked: revoked,
      serviceBase: serviceBase,
      protocolVersion: protocolVersion,
      serviceName: serviceName,
      privacyUrl: privacyUrl,
      supportUrl: supportUrl,
      features: features,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'url': url,
    if (accountLabel != null && accountLabel!.isNotEmpty)
      'accountLabel': accountLabel,
    if (lastFetched != null)
      'lastFetched': lastFetched!.toUtc().toIso8601String(),
    'intervalHours': intervalHours,
    if (userinfo != null) 'userinfo': userinfo!.toJson(),
    if (revoked) 'revoked': true,
    if (serviceBase != null) 'serviceBase': serviceBase,
    if (protocolVersion != null) 'protocolVersion': protocolVersion,
    if (serviceName != null) 'serviceName': serviceName,
    if (privacyUrl != null) 'privacyUrl': privacyUrl,
    if (supportUrl != null) 'supportUrl': supportUrl,
    if (features.isNotEmpty) 'features': features,
  };

  static VpnSubscription fromJson(Map<String, dynamic> json) {
    final fetched = json['lastFetched'] as String?;
    final version = (json['protocolVersion'] as num?)?.toInt();
    final base = _serviceBaseFromJson(json['serviceBase']);
    return VpnSubscription(
      id: (json['id'] as String?)?.trim().isNotEmpty == true
          ? json['id'] as String
          : newId(),
      name: (json['name'] as String?)?.trim() ?? '',
      url: (json['url'] as String?)?.trim() ?? '',
      accountLabel: _optionalString(json['accountLabel']),
      lastFetched: fetched == null ? null : DateTime.tryParse(fetched),
      intervalHours: (json['intervalHours'] as num?)?.toInt() ?? 24,
      userinfo: SubscriptionUserinfo.fromJson(
        json['userinfo'] is Map
            ? Map<String, dynamic>.from(json['userinfo'] as Map)
            : null,
      ),
      revoked: json['revoked'] == true,
      serviceBase: base,
      protocolVersion: base != null && version != null && version > 0
          ? version
          : null,
      serviceName: base == null ? null : _optionalString(json['serviceName']),
      privacyUrl: base == null ? null : _httpsUrlFromJson(json['privacyUrl']),
      supportUrl: base == null ? null : _httpsUrlFromJson(json['supportUrl']),
      features: base == null ? const [] : _stringList(json['features']),
    );
  }

  static String? _serviceBaseFromJson(Object? raw) {
    if (raw is! String) return null;
    final uri = Uri.tryParse(raw.trim());
    if (uri == null || uri.userInfo.isNotEmpty) return null;
    return httpsOrigin(uri);
  }

  static String? _httpsUrlFromJson(Object? raw) {
    if (raw is! String) return null;
    final uri = Uri.tryParse(raw.trim());
    if (uri == null ||
        uri.userInfo.isNotEmpty ||
        uri.scheme.toLowerCase() != 'https' ||
        uri.host.isEmpty) {
      return null;
    }
    return uri.toString();
  }

  static String? _optionalString(Object? raw) {
    if (raw is! String) return null;
    final t = raw.trim();
    return t.isEmpty ? null : t;
  }

  static List<String> _stringList(Object? raw) {
    if (raw is! List) return const [];
    final out = <String>[];
    for (final item in raw) {
      if (item is! String) continue;
      final t = item.trim();
      if (t.isEmpty) continue;
      out.add(t);
      if (out.length >= 32) break;
    }
    return out;
  }

  static VpnSubscription fromUrl(String url, {String? name}) {
    return VpnSubscription(
      id: newId(),
      name: (name ?? '').trim(),
      url: url.trim(),
    );
  }

  static String newId() =>
      's_${DateTime.now().microsecondsSinceEpoch}_${Object().hashCode.abs()}';

  static String encodeList(List<VpnSubscription> items) =>
      jsonEncode(items.map((e) => e.toJson()).toList());

  static List<VpnSubscription> decodeList(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return decoded
        .whereType<Map>()
        .map((e) => VpnSubscription.fromJson(Map<String, dynamic>.from(e)))
        .where((s) => s.url.isNotEmpty)
        .toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VpnSubscription &&
          other.id == id &&
          other.name == name &&
          other.url == url &&
          other.accountLabel == accountLabel &&
          other.lastFetched == lastFetched &&
          other.intervalHours == intervalHours &&
          other.revoked == revoked &&
          other.serviceBase == serviceBase &&
          other.protocolVersion == protocolVersion &&
          other.serviceName == serviceName &&
          other.privacyUrl == privacyUrl &&
          other.supportUrl == supportUrl &&
          _sameStrings(other.features, features);

  @override
  int get hashCode => Object.hash(
    id,
    name,
    url,
    accountLabel,
    lastFetched,
    intervalHours,
    revoked,
    serviceBase,
    protocolVersion,
    serviceName,
    privacyUrl,
    supportUrl,
    Object.hashAll(features),
  );
}

bool _sameStrings(List<String> a, List<String> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// Quota chip on Home: the selected profile's subscription, or the only one.
VpnSubscription? quotaSubscriptionFor({
  required List<VpnSubscription> subscriptions,
  SavedProfile? profile,
}) {
  final subId = profile?.subscriptionId;
  if (subId != null) {
    for (final sub in subscriptions) {
      if (sub.id == subId) return sub;
    }
  }
  if (subscriptions.length == 1) return subscriptions.single;
  return null;
}

/// Subscription that owns [shareLink], if any.
VpnSubscription? subscriptionForShareLink({
  required List<VpnSubscription> subscriptions,
  required List<SavedProfile> savedProfiles,
  required String? shareLink,
}) {
  if (shareLink == null || shareLink.trim().isEmpty) return null;
  SavedProfile? profile;
  for (final item in savedProfiles) {
    if (item.link == shareLink) {
      profile = item;
      break;
    }
  }
  final subId = profile?.subscriptionId;
  if (subId == null) return null;
  for (final sub in subscriptions) {
    if (sub.id == subId) return sub;
  }
  return null;
}

bool looksLikeSubscriptionUrl(String raw) {
  final uri = Uri.tryParse(raw.trim());
  return uri != null &&
      (uri.scheme == 'http' || uri.scheme == 'https') &&
      uri.host.isNotEmpty;
}
