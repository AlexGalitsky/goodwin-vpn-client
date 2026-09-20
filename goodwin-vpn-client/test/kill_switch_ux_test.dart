import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/features/settings/presentation/kill_switch_ux.dart';
import 'package:goodwin_vpn_client/l10n/app_localizations_en.dart';

void main() {
  test('Android Kill Switch stays off unless user returned and confirmed', () {
    expect(
      androidKillSwitchShouldTurnOn(
        returnedFromSettings: false,
        confirmedAlwaysOn: true,
      ),
      isFalse,
    );
    expect(
      androidKillSwitchShouldTurnOn(
        returnedFromSettings: true,
        confirmedAlwaysOn: false,
      ),
      isFalse,
    );
    expect(
      androidKillSwitchShouldTurnOn(
        returnedFromSettings: true,
        confirmedAlwaysOn: null,
      ),
      isFalse,
    );
    expect(
      androidKillSwitchShouldTurnOn(
        returnedFromSettings: true,
        confirmedAlwaysOn: true,
      ),
      isTrue,
    );
  });

  test('Settings KS subtitle is short and not leak-proof', () {
    final l10n = AppLocalizationsEn();
    final android = killSwitchSettingsSubtitle(l10n, isIos: false);
    expect(android, contains('not leak-proof'));
    expect(android.toLowerCase(), isNot(contains('xray')));
    expect(android.toLowerCase(), isNot(contains('hysteria')));
    expect(android.toLowerCase(), isNot(contains('trusttunnel')));
    final ios = killSwitchSettingsSubtitle(l10n, isIos: true);
    expect(ios.toLowerCase(), isNot(contains('leak-proof')));
  });

  testWidgets('waitUntilAppReturned is false when settings never take over',
      (tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    final returned = waitUntilAppReturned(
      leave: () async {},
      stillHere: const Duration(milliseconds: 20),
      timeout: const Duration(milliseconds: 50),
    );
    await tester.pump(const Duration(milliseconds: 80));
    expect(await returned, isFalse);
  });
}
