/// Unwraps `goodwin://import?url=` (and `link=`) so paste / QR / deeplink share one path.
class ImportUriException implements Exception {
  const ImportUriException(this.message);
  final String message;

  @override
  String toString() => message;
}

String unwrapImportText(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return '';
  final uri = Uri.tryParse(trimmed);
  if (uri == null || uri.scheme.toLowerCase() != 'goodwin') {
    return trimmed;
  }
  final importHost = uri.host.toLowerCase() == 'import';
  final importPath = uri.path == '/import' ||
      uri.pathSegments.map((s) => s.toLowerCase()).contains('import');
  if (!importHost && !importPath) return trimmed;
  final payload = uri.queryParameters['url'] ??
      uri.queryParameters['link'] ??
      uri.queryParameters['s'];
  final value = payload?.trim() ?? '';
  if (value.isEmpty) {
    throw const ImportUriException(
      'goodwin://import needs url= (share link or https subscription)',
    );
  }
  return value;
}

bool isGoodwinImportUri(Uri uri) {
  if (uri.scheme.toLowerCase() != 'goodwin') return false;
  return uri.host.toLowerCase() == 'import' ||
      uri.path == '/import' ||
      uri.pathSegments.map((s) => s.toLowerCase()).contains('import');
}
