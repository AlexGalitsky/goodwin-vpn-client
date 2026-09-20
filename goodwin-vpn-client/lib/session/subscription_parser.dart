import 'dart:convert';

import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';

import 'subscription.dart';

class SubscriptionParseException implements Exception {
  SubscriptionParseException(this.message);
  final String message;

  @override
  String toString() => 'SubscriptionParseException: $message';
}

/// Panel rotated the token: old URL is 404. Keep the last catalog.
class SubscriptionRevokedException extends SubscriptionParseException {
  SubscriptionRevokedException()
      : super('This subscription link was revoked. Paste a new URL.');
}

class ParsedSubscription {
  const ParsedSubscription({
    required this.links,
    this.title,
    this.intervalHours,
    this.userinfo,
  });

  final List<String> links;
  final String? title;
  final int? intervalHours;
  final SubscriptionUserinfo? userinfo;
}

class SubscriptionDocument {
  const SubscriptionDocument({
    required this.body,
    this.headers = const {},
  });

  final String body;
  final Map<String, String> headers;
}

ParsedSubscription parseSubscriptionDocument(SubscriptionDocument doc) {
  final fromHeaders = _metaFromMap(doc.headers);
  final fromBody = _parseBody(doc.body);
  final links = fromBody.links;
  if (links.isEmpty) {
    if (doc.body.trim().isEmpty) {
      return ParsedSubscription(
        links: const [],
        title: fromHeaders.title,
        intervalHours: fromHeaders.intervalHours,
        userinfo: fromHeaders.userinfo,
      );
    }
    throw SubscriptionParseException('No share links in subscription');
  }
  return ParsedSubscription(
    links: links,
    title: fromHeaders.title ?? fromBody.title,
    intervalHours: fromHeaders.intervalHours ?? fromBody.intervalHours,
    userinfo: fromHeaders.userinfo ?? fromBody.userinfo,
  );
}

({String? title, int? intervalHours, SubscriptionUserinfo? userinfo})
    _metaFromMap(Map<String, String> headers) {
  String? get(String key) {
    for (final entry in headers.entries) {
      if (entry.key.toLowerCase() == key) {
        final v = entry.value.trim();
        if (v.isNotEmpty) return v;
      }
    }
    return null;
  }

  return (
    title: decodeProfileTitle(get('profile-title')),
    intervalHours: int.tryParse(get('profile-update-interval') ?? ''),
    userinfo: SubscriptionUserinfo.parseHeader(get('subscription-userinfo')),
  );
}

ParsedSubscription _parseBody(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) {
    return const ParsedSubscription(links: []);
  }
  if (_looksLikeClash(trimmed)) {
    throw SubscriptionParseException('Clash YAML is not supported');
  }

  var text = trimmed;
  var links = _extractLinks(text);
  var meta = _metaFromComments(text);
  if (links.isEmpty) {
    final decoded = _tryBase64(trimmed);
    if (decoded != null) {
      if (_looksLikeClash(decoded)) {
        throw SubscriptionParseException('Clash YAML is not supported');
      }
      text = decoded;
      links = _extractLinks(decoded);
      meta = _metaFromComments(decoded);
    }
  }
  return ParsedSubscription(
    links: links,
    title: meta.title,
    intervalHours: meta.intervalHours,
    userinfo: meta.userinfo,
  );
}

bool _looksLikeClash(String text) {
  final head = text.substring(0, text.length > 400 ? 400 : text.length);
  return head.contains('proxies:') &&
      !head.contains('vless://') &&
      !head.contains('vmess://');
}

List<String> _extractLinks(String text) {
  final seen = <String>{};
  final out = <String>[];
  for (final line in text.split(RegExp(r'[\r\n]+'))) {
    var candidate = line.trim();
    if (candidate.startsWith('#')) continue;
    if (candidate.startsWith('http://') || candidate.startsWith('https://')) {
      continue;
    }
    if (!_looksLikeShareScheme(candidate)) continue;
    try {
      const ShareLinkParser().parse(candidate);
    } catch (_) {
      continue;
    }
    if (seen.add(candidate)) out.add(candidate);
  }
  return out;
}

bool _looksLikeShareScheme(String line) {
  final scheme = line.contains('://') ? line.split('://').first.toLowerCase() : '';
  return const {
    'vless',
    'vmess',
    'trojan',
    'hysteria2',
    'hy2',
    'tt',
  }.contains(scheme);
}

({String? title, int? intervalHours, SubscriptionUserinfo? userinfo})
    _metaFromComments(String text) {
  final headers = <String, String>{};
  for (final line in text.split(RegExp(r'[\r\n]+'))) {
    final t = line.trim();
    if (!t.startsWith('#')) continue;
    var body = t.substring(1).trim();
    if (body.startsWith('#')) body = body.substring(1).trim();
    final i = body.indexOf(':');
    if (i <= 0) continue;
    headers[body.substring(0, i).trim().toLowerCase()] =
        body.substring(i + 1).trim();
  }
  return _metaFromMap(headers);
}

String? decodeProfileTitle(String? raw) {
  if (raw == null) return null;
  var t = raw.trim();
  if (t.startsWith('base64:')) t = t.substring(7).trim();
  if (t.isEmpty) return null;
  if (!t.contains(' ') && t.length >= 8 && RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(t)) {
    try {
      final decoded = utf8.decode(base64Decode(_padBase64(t)));
      if (decoded.trim().isNotEmpty) return decoded.trim();
    } catch (_) {}
  }
  return t;
}

String? _tryBase64(String raw) {
  final compact = raw.replaceAll(RegExp(r'\s'), '');
  if (compact.length < 8 || !RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(compact)) {
    return null;
  }
  try {
    return utf8.decode(base64Decode(_padBase64(compact)));
  } catch (_) {
    return null;
  }
}

String _padBase64(String raw) {
  final mod = raw.length % 4;
  if (mod == 0) return raw;
  return raw.padRight(raw.length + (4 - mod), '=');
}
