import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/core/config/theme_preference.dart';
import 'package:goodwin_vpn_client/core/config/ui_mode.dart';
import 'package:goodwin_vpn_client/l10n/app_localizations.dart';
import 'package:goodwin_vpn_client/ui/ui.dart';

void main() {
  test('UiMode parse', () {
    expect(UiMode.parse(null), UiMode.standard);
    expect(UiMode.parse('standard'), UiMode.standard);
    expect(UiMode.parse('advanced'), UiMode.advanced);
  });

  test('ThemePreference parse', () {
    expect(ThemePreference.parse(null), ThemePreference.system);
    expect(ThemePreference.parse('light'), ThemePreference.light);
    expect(ThemePreference.parse('dark'), ThemePreference.dark);
    expect(ThemePreference.light.themeMode, ThemeMode.light);
    expect(ThemePreference.dark.themeMode, ThemeMode.dark);
  });

  test('light palette is paper, not navy', () {
    expect(GwColors.light.canvas, const Color(0xFFF4F7FB));
    expect(GwColors.light.card, const Color(0xFFFFFFFF));
    expect(GwColors.light.inset, const Color(0xFFE8EEF4));
    expect(GwColors.dark.canvas, const Color(0xFF0B101A));
  });

  testWidgets('theme picker reports Light', (tester) async {
    ThemePreference? picked;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildGwTheme(Brightness.light),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: GwThemePicker(
            value: ThemePreference.system,
            onChanged: (next) => picked = next,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Light'));
    expect(picked, ThemePreference.light);
  });
}
