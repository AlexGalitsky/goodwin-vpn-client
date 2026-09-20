import 'models/routing_models.dart';

/// Free-text matcher → typed form for Xray `routing.rules`.
enum RoutingMatchKind {
  /// IPv4 / IPv6 address or CIDR → Xray `ip` field.
  ip,

  /// Full / root domain → Xray `domain:…`.
  domain,

  /// Suffix (UI often `.example.com`) → Xray `domain:…` (subdomain match).
  domainSuffix,
}

class ParsedRoutingMatcher {
  const ParsedRoutingMatcher({
    required this.kind,
    required this.value,
  });

  final RoutingMatchKind kind;

  /// Normalized value (no leading `.` for suffixes; CIDR/IP as typed).
  final String value;

  /// Entry for Xray `domain` array, or null when [kind] is [RoutingMatchKind.ip].
  String? get xrayDomainEntry {
    return switch (kind) {
      RoutingMatchKind.ip => null,
      RoutingMatchKind.domain || RoutingMatchKind.domainSuffix =>
        'domain:$value',
    };
  }

  /// Entry for Xray `ip` array, or null when domain-like.
  String? get xrayIpEntry {
    return kind == RoutingMatchKind.ip ? value : null;
  }
}

/// Parse Advanced free-text matcher (domain suffix, IP, or CIDR).
ParsedRoutingMatcher? parseRoutingMatcher(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return null;

  if (_looksLikeIpOrCidr(trimmed)) {
    return ParsedRoutingMatcher(
      kind: RoutingMatchKind.ip,
      value: trimmed,
    );
  }

  if (trimmed.startsWith('.')) {
    final withoutDot = trimmed.substring(1).trim();
    if (withoutDot.isEmpty || !_looksLikeDomain(withoutDot)) return null;
    return ParsedRoutingMatcher(
      kind: RoutingMatchKind.domainSuffix,
      value: withoutDot.toLowerCase(),
    );
  }

  if (!_looksLikeDomain(trimmed)) return null;
  return ParsedRoutingMatcher(
    kind: RoutingMatchKind.domain,
    value: trimmed.toLowerCase(),
  );
}

String outboundTagFor(RoutingAction action) => switch (action) {
      RoutingAction.proxy => 'proxy',
      RoutingAction.direct => 'direct',
      RoutingAction.block => 'block',
    };

bool _looksLikeIpOrCidr(String value) {
  final slash = value.indexOf('/');
  final host = slash >= 0 ? value.substring(0, slash) : value;
  final prefix = slash >= 0 ? value.substring(slash + 1) : null;
  if (prefix != null) {
    final bits = int.tryParse(prefix);
    if (bits == null || bits < 0) return false;
  }

  if (_isIpv4(host)) {
    if (prefix != null && int.parse(prefix) > 32) return false;
    return true;
  }
  if (_isIpv6(host)) {
    if (prefix != null && int.parse(prefix) > 128) return false;
    return true;
  }
  return false;
}

bool _isIpv4(String host) {
  final parts = host.split('.');
  if (parts.length != 4) return false;
  for (final part in parts) {
    final n = int.tryParse(part);
    if (n == null || n < 0 || n > 255) return false;
  }
  return true;
}

bool _isIpv6(String host) {
  if (!host.contains(':')) return false;
  if (host.contains(':::')) return false;
  final cleaned = host.startsWith('[') && host.endsWith(']')
      ? host.substring(1, host.length - 1)
      : host;
  final parts = cleaned.split('::');
  if (parts.length > 2) return false;
  for (final side in parts) {
    if (side.isEmpty) continue;
    for (final group in side.split(':')) {
      if (group.isEmpty) return false;
      if (int.tryParse(group, radix: 16) == null) return false;
      if (group.length > 4) return false;
    }
  }
  return true;
}

bool _looksLikeDomain(String value) {
  if (value.contains(' ') || value.contains('/')) return false;
  if (value.startsWith('-') || value.endsWith('-') || value.endsWith('.')) {
    return false;
  }
  final labels = value.split('.');
  if (labels.isEmpty) return false;
  final labelRe = RegExp(r'^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$');
  final singleRe = RegExp(r'^[a-zA-Z0-9]$');
  for (final label in labels) {
    if (label.isEmpty) return false;
    if (label.length == 1) {
      if (!singleRe.hasMatch(label)) return false;
    } else if (!labelRe.hasMatch(label)) {
      return false;
    }
  }
  return true;
}
