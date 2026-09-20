/// Strip share-link secrets and subscription tokens from session logs.
String redactForLog(String line) {
  var out = line;
  out = out.replaceAllMapped(
    RegExp(
      r'(vless|vmess|trojan|hysteria2|hy2|ss|tt)://\S+',
      caseSensitive: false,
    ),
    (m) => '${m[1]}://…',
  );
  out = out.replaceAllMapped(
    RegExp(
      r'https://[^\s]+/sub/[^\s/?#]+',
      caseSensitive: false,
    ),
    (m) {
      final uri = Uri.tryParse(m[0]!);
      if (uri == null || uri.host.isEmpty) return 'https://…/sub/…';
      return '${uri.scheme}://${uri.host}/sub/…';
    },
  );
  out = out.replaceAll(
    RegExp(
      r'[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}',
    ),
    '…',
  );
  return out;
}
