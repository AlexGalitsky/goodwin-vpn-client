import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/features/logs/domain/log_line.dart';

void main() {
  group('parseLogLine', () {
    test('detects error and warning keywords', () {
      expect(parseLogLine('ok').level, LogLineLevel.info);
      expect(parseLogLine('WARN: slow').level, LogLineLevel.warning);
      expect(parseLogLine('connect failed').level, LogLineLevel.error);
    });
  });

  group('filterLogLines', () {
    const lines = [
      'info hello',
      'WARN slow path',
      'error boom',
    ];

    test('filters by query', () {
      expect(filterLogLines(lines, query: 'warn'), ['WARN slow path']);
    });

    test('filters by min level', () {
      expect(
        filterLogLines(lines, minLevel: LogLineLevel.warning),
        ['WARN slow path', 'error boom'],
      );
      expect(
        filterLogLines(lines, minLevel: LogLineLevel.error),
        ['error boom'],
      );
    });
  });
}
