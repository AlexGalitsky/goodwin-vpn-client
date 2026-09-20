import 'package:flutter/material.dart';

import '../theme/gw_colors.dart';
import '../theme/gw_spacing.dart';

/// Modal bottom sheet that lists exclusive options (theme, locale, DNS mode…).
Future<T?> showGwOptionSheet<T>({
  required BuildContext context,
  required String title,
  String? subtitle,
  required List<GwSheetOption<T>> options,
  T? selected,
}) {
  return showModalBottomSheet<T>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (ctx) {
      final gw = ctx.gw;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            GwSpacing.screen,
            0,
            GwSpacing.screen,
            GwSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: Theme.of(ctx).textTheme.titleMedium),
              if (subtitle != null && subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                        color: gw.textMuted,
                      ),
                ),
              ],
              const SizedBox(height: 12),
              for (final opt in options)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(opt.label),
                  subtitle: opt.subtitle == null
                      ? null
                      : Text(opt.subtitle!),
                  trailing: selected == opt.value
                      ? Icon(Icons.check_rounded, color: gw.accent)
                      : null,
                  onTap: () => Navigator.of(ctx).pop(opt.value),
                ),
            ],
          ),
        ),
      );
    },
  );
}

class GwSheetOption<T> {
  const GwSheetOption({
    required this.value,
    required this.label,
    this.subtitle,
  });

  final T value;
  final String label;
  final String? subtitle;
}
