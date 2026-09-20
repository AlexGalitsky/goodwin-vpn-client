enum LogLineLevel { info, warning, error }

class ParsedLogLine {
  const ParsedLogLine({required this.raw, required this.level});

  final String raw;
  final LogLineLevel level;
}

ParsedLogLine parseLogLine(String raw) {
  final lower = raw.toLowerCase();
  if (lower.contains('error') ||
      lower.contains('failed') ||
      lower.contains('exception')) {
    return ParsedLogLine(raw: raw, level: LogLineLevel.error);
  }
  if (lower.contains('warn') || lower.contains('denied')) {
    return ParsedLogLine(raw: raw, level: LogLineLevel.warning);
  }
  return ParsedLogLine(raw: raw, level: LogLineLevel.info);
}

List<String> filterLogLines(
  List<String> lines, {
  String query = '',
  LogLineLevel? minLevel,
}) {
  final q = query.trim().toLowerCase();
  return [
    for (final line in lines)
      if (_matches(line, q: q, minLevel: minLevel)) line,
  ];
}

bool _matches(
  String line, {
  required String q,
  required LogLineLevel? minLevel,
}) {
  if (q.isNotEmpty && !line.toLowerCase().contains(q)) return false;
  if (minLevel == null) return true;
  final level = parseLogLine(line).level;
  return switch (minLevel) {
    LogLineLevel.info => true,
    LogLineLevel.warning =>
      level == LogLineLevel.warning || level == LogLineLevel.error,
    LogLineLevel.error => level == LogLineLevel.error,
  };
}
