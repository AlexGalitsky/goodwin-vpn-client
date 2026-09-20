import 'package:flutter/material.dart';

import '../domain/log_line.dart';

class LogsConsoleView extends StatelessWidget {
  const LogsConsoleView({
    super.key,
    required this.lines,
    this.padding = const EdgeInsets.all(12),
    this.emptyLabel = 'No log lines yet',
  });

  final List<String> lines;
  final EdgeInsetsGeometry padding;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (lines.isEmpty) {
      return Center(
        child: Text(
          emptyLabel,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).hintColor,
              ),
        ),
      );
    }

    final base = Theme.of(context).textTheme.bodySmall;
    return SelectionArea(
      child: ListView.builder(
        padding: padding,
        itemCount: lines.length,
        itemBuilder: (context, index) {
          final parsed = parseLogLine(lines[index]);
          return Text(
            parsed.raw,
            style: base?.copyWith(
              fontFamily: 'Consolas',
              fontFamilyFallback: const ['Courier New', 'monospace'],
              color: _color(context, parsed.level),
            ),
          );
        },
      ),
    );
  }

  Color _color(BuildContext context, LogLineLevel level) {
    final scheme = Theme.of(context).colorScheme;
    return switch (level) {
      LogLineLevel.info => scheme.onSurface.withValues(alpha: 0.75),
      LogLineLevel.warning => const Color(0xFFB45309),
      LogLineLevel.error => scheme.error,
    };
  }
}
