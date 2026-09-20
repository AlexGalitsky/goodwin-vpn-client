/// Best-effort location hint from a share-link remark / profile name.
///
/// Only surfaces what panels already put in the remark (flag emoji, ISO code).
/// Returns null when nothing location-like is present — no IP/geo lookup.
String? profileLocationHint(String remark) {
  final t = remark.trim();
  if (t.isEmpty) return null;

  final flag = RegExp(
    r'^((?:[\u{1F1E6}-\u{1F1FF}]{2}))\s*(.*)$',
    unicode: true,
  ).firstMatch(t);
  if (flag != null) {
    final emoji = flag.group(1)!;
    final rest = _firstSegment(flag.group(2)!);
    if (rest.isEmpty) return emoji;
    return '$emoji $rest';
  }

  final code = RegExp(r'^[\[\(]([A-Za-z]{2})[\]\)]\s*(.*)$').firstMatch(t);
  if (code != null) {
    final iso = code.group(1)!.toUpperCase();
    final rest = _firstSegment(code.group(2)!);
    if (rest.isEmpty) return iso;
    return '$iso · $rest';
  }

  return null;
}

String _firstSegment(String raw) {
  var s = raw.trim();
  if (s.isEmpty) return '';
  s = s.split(RegExp(r'\s*[|·•]\s*')).first.trim();
  s = s.replaceFirst(RegExp(r'^[\-\–—]\s*'), '').trim();
  if (s.length > 36) return '${s.substring(0, 36)}…';
  return s;
}
