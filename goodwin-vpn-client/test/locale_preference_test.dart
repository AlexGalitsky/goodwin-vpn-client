import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/core/config/locale_preference.dart';
import 'package:goodwin_vpn_client/l10n/app_localizations.dart';

void main() {
  test('LocalePreference covers every generated locale plus system', () {
    final codes = LocalePreference.values
        .where((v) => v != LocalePreference.system)
        .map((v) => v.name)
        .toSet();
    expect(
      codes,
      AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet(),
    );
  });

  test('parse unknown storage values as system', () {
    expect(LocalePreference.parse(null), LocalePreference.system);
    expect(LocalePreference.parse('ja'), LocalePreference.ja);
    expect(LocalePreference.parse('xx'), LocalePreference.system);
    expect(LocalePreference.pt.locale?.languageCode, 'pt');
  });
}
