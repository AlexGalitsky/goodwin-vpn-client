import 'package:flutter/material.dart';

/// Semantic colors for the Universal VPN mock (cyan + emerald on cool navy / paper).
@immutable
class GwColors extends ThemeExtension<GwColors> {
  const GwColors({
    required this.canvas,
    required this.canvasGlow,
    required this.card,
    required this.cardBorder,
    required this.accent,
    required this.accentMuted,
    required this.accentOn,
    required this.success,
    required this.successMuted,
    required this.successOn,
    required this.warning,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textFaint,
    required this.navBar,
    required this.trackOff,
    required this.inset,
    required this.shadow,
  });

  final Color canvas;
  final Color canvasGlow;
  final Color card;
  final Color cardBorder;
  final Color accent;
  final Color accentMuted;
  final Color accentOn;
  final Color success;
  final Color successMuted;
  final Color successOn;
  final Color warning;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textFaint;
  final Color navBar;
  final Color trackOff;
  final Color inset;
  final Color shadow;

  static const dark = GwColors(
    canvas: Color(0xFF0B101A),
    canvasGlow: Color(0x29166793),
    card: Color(0xFF151D2B),
    cardBorder: Color(0x14FFFFFF),
    accent: Color(0xFF22D3EE),
    accentMuted: Color(0x2622D3EE),
    accentOn: Color(0xFF061115),
    success: Color(0xFF34D399),
    successMuted: Color(0x1A34D399),
    successOn: Color(0xFF08130F),
    warning: Color(0xFFFBBF24),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFF94A3B8),
    textMuted: Color(0xFF64748B),
    textFaint: Color(0xFF475569),
    navBar: Color(0xE60B101A),
    trackOff: Color(0x1AFFFFFF),
    inset: Color(0xFF1C2535),
    shadow: Color(0x66000000),
  );

  static const light = GwColors(
    canvas: Color(0xFFF4F7FB),
    canvasGlow: Color(0x3D7DD3E8),
    card: Color(0xFFFFFFFF),
    cardBorder: Color(0x1A0F172A),
    accent: Color(0xFF0E7490),
    accentMuted: Color(0x3322D3EE),
    accentOn: Color(0xFFFFFFFF),
    success: Color(0xFF047857),
    successMuted: Color(0x2434D399),
    successOn: Color(0xFFFFFFFF),
    warning: Color(0xFFB45309),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF334155),
    textMuted: Color(0xFF64748B),
    textFaint: Color(0xFF94A3B8),
    navBar: Color(0xF7FFFFFF),
    trackOff: Color(0x1A0F172A),
    inset: Color(0xFFE8EEF4),
    shadow: Color(0x1A0F172A),
  );

  @override
  GwColors copyWith({
    Color? canvas,
    Color? canvasGlow,
    Color? card,
    Color? cardBorder,
    Color? accent,
    Color? accentMuted,
    Color? accentOn,
    Color? success,
    Color? successMuted,
    Color? successOn,
    Color? warning,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textFaint,
    Color? navBar,
    Color? trackOff,
    Color? inset,
    Color? shadow,
  }) {
    return GwColors(
      canvas: canvas ?? this.canvas,
      canvasGlow: canvasGlow ?? this.canvasGlow,
      card: card ?? this.card,
      cardBorder: cardBorder ?? this.cardBorder,
      accent: accent ?? this.accent,
      accentMuted: accentMuted ?? this.accentMuted,
      accentOn: accentOn ?? this.accentOn,
      success: success ?? this.success,
      successMuted: successMuted ?? this.successMuted,
      successOn: successOn ?? this.successOn,
      warning: warning ?? this.warning,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textFaint: textFaint ?? this.textFaint,
      navBar: navBar ?? this.navBar,
      trackOff: trackOff ?? this.trackOff,
      inset: inset ?? this.inset,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  GwColors lerp(GwColors? other, double t) {
    if (other is! GwColors) return this;
    return GwColors(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      canvasGlow: Color.lerp(canvasGlow, other.canvasGlow, t)!,
      card: Color.lerp(card, other.card, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentMuted: Color.lerp(accentMuted, other.accentMuted, t)!,
      accentOn: Color.lerp(accentOn, other.accentOn, t)!,
      success: Color.lerp(success, other.success, t)!,
      successMuted: Color.lerp(successMuted, other.successMuted, t)!,
      successOn: Color.lerp(successOn, other.successOn, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textFaint: Color.lerp(textFaint, other.textFaint, t)!,
      navBar: Color.lerp(navBar, other.navBar, t)!,
      trackOff: Color.lerp(trackOff, other.trackOff, t)!,
      inset: Color.lerp(inset, other.inset, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

extension GwThemeContext on BuildContext {
  GwColors get gw {
    final theme = Theme.of(this);
    return theme.extension<GwColors>() ??
        (theme.brightness == Brightness.light ? GwColors.light : GwColors.dark);
  }
}
