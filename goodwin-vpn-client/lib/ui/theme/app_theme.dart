import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'gw_colors.dart';
import 'gw_spacing.dart';
import 'gw_typography.dart';

export 'gw_colors.dart';
export 'gw_spacing.dart';
export 'gw_typography.dart';

ThemeData buildGwTheme(Brightness brightness) {
  final colors = brightness == Brightness.dark ? GwColors.dark : GwColors.light;
  final base = ThemeData(brightness: brightness, useMaterial3: true);
  final textTheme = GwTypography.textTheme(base.textTheme, colors);
  final isDark = brightness == Brightness.dark;

  final scheme = ColorScheme.fromSeed(
    seedColor: colors.accent,
    brightness: brightness,
  ).copyWith(
    primary: colors.accent,
    onPrimary: colors.accentOn,
    secondary: colors.success,
    onSecondary: colors.successOn,
    surface: colors.card,
    onSurface: colors.textPrimary,
    onSurfaceVariant: colors.textSecondary,
    error: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
    onError: isDark ? const Color(0xFF0B101A) : Colors.white,
    outline: colors.cardBorder,
    outlineVariant: colors.cardBorder,
    surfaceContainerLowest: colors.canvas,
    surfaceContainerLow: colors.inset,
    surfaceContainer: colors.card,
    surfaceContainerHigh: colors.inset,
    surfaceContainerHighest: colors.inset,
  );

  final overlay = (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
      .copyWith(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: colors.navBar,
    systemNavigationBarIconBrightness:
        isDark ? Brightness.light : Brightness.dark,
  );

  final radius = BorderRadius.circular(GwRadius.md);

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: 'Inter',
    colorScheme: scheme,
    scaffoldBackgroundColor: colors.canvas,
    canvasColor: colors.canvas,
    textTheme: textTheme,
    extensions: [colors],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: colors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: textTheme.headlineMedium,
      systemOverlayStyle: overlay,
    ),
    dividerColor: colors.cardBorder,
    dividerTheme: DividerThemeData(
      color: colors.cardBorder,
      thickness: 1,
      space: 1,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colors.accent,
        foregroundColor: colors.accentOn,
        textStyle: textTheme.labelLarge,
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.textPrimary,
        side: BorderSide(color: colors.cardBorder),
        textStyle: textTheme.labelLarge,
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colors.accent,
        textStyle: textTheme.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colors.inset,
      hintStyle: textTheme.bodyMedium?.copyWith(color: colors.textFaint),
      labelStyle: textTheme.bodySmall,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(GwRadius.lg),
        borderSide: BorderSide(color: colors.cardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(GwRadius.lg),
        borderSide: BorderSide(color: colors.cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(GwRadius.lg),
        borderSide: BorderSide(color: colors.accent, width: 1.4),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: colors.card,
      selectedColor: colors.accentMuted,
      labelStyle: textTheme.bodySmall?.copyWith(color: colors.textPrimary),
      secondaryLabelStyle:
          textTheme.bodySmall?.copyWith(color: colors.accent),
      side: BorderSide(color: colors.cardBorder),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GwRadius.full),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return colors.accent;
        return colors.trackOff;
      }),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: colors.card,
      contentTextStyle:
          textTheme.bodyMedium?.copyWith(color: colors.textPrimary),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GwRadius.lg),
        side: BorderSide(color: colors.cardBorder),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: colors.card,
      titleTextStyle: textTheme.titleLarge,
      contentTextStyle: textTheme.bodyMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GwRadius.xl),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(GwRadius.xl)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colors.navBar,
      indicatorColor: colors.accentMuted,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final active = states.contains(WidgetState.selected);
        return textTheme.labelSmall?.copyWith(
          letterSpacing: 0.2,
          color: active ? colors.accent : colors.textFaint,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final active = states.contains(WidgetState.selected);
        return IconThemeData(
          color: active ? colors.accent : colors.textFaint,
          size: 20,
        );
      }),
    ),
  );
}
