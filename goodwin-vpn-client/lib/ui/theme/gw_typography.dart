import 'package:flutter/material.dart';

import 'gw_colors.dart';

abstract final class GwTypography {
  static TextTheme textTheme(TextTheme base, GwColors colors) {
    final inter = base.apply(fontFamily: 'Inter');
    return inter.copyWith(
      headlineMedium: inter.headlineMedium?.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.4,
        color: colors.textPrimary,
      ),
      titleLarge: inter.titleLarge?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: colors.textPrimary,
      ),
      titleMedium: inter.titleMedium?.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: colors.textPrimary,
      ),
      titleSmall: inter.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.3,
        color: colors.textPrimary,
      ),
      bodyMedium: inter.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: colors.textSecondary,
      ),
      bodySmall: inter.bodySmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.35,
        color: colors.textMuted,
      ),
      labelLarge: inter.labelLarge?.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: colors.textPrimary,
      ),
      labelMedium: inter.labelMedium?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 1.6,
        color: colors.textMuted,
      ),
      labelSmall: inter.labelSmall?.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 1.8,
        color: colors.textMuted,
      ),
    );
  }

  static TextStyle mono(TextTheme theme, Color color) {
    return (theme.bodySmall ?? const TextStyle(fontSize: 11)).copyWith(
      fontFamily: 'Menlo',
      fontFamilyFallback: const ['Consolas', 'Courier New', 'monospace'],
      color: color,
      height: 1.45,
    );
  }
}
