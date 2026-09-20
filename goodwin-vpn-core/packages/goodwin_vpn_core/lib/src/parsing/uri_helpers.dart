Map<String, String> queryMap(Uri uri) {
  final out = <String, String>{};
  uri.queryParameters.forEach((key, value) {
    out[key] = value;
  });
  return out;
}

String? emptyToNull(String? value) {
  if (value == null) return null;
  final t = value.trim();
  return t.isEmpty ? null : t;
}

String fragmentName(Uri uri, {required String fallback}) {
  if (uri.fragment.isEmpty) return fallback;
  return Uri.decodeComponent(uri.fragment);
}
