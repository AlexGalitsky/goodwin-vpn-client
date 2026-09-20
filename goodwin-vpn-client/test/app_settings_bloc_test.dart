import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:goodwin_vpn_client/core/config/dns_mode.dart';
import 'package:goodwin_vpn_client/core/config/locale_preference.dart';
import 'package:goodwin_vpn_client/core/config/theme_preference.dart';
import 'package:goodwin_vpn_client/core/config/ui_mode.dart';
import 'package:goodwin_vpn_client/features/settings/presentation/bloc/app_settings_bloc.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppSettingsBloc VPN prefs', () {
    test('persists dns mode and mux', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final bloc = AppSettingsBloc(prefs: prefs);
      addTearDown(bloc.close);

      expect(bloc.state.uiMode, UiMode.standard);
      expect(bloc.state.themePreference, ThemePreference.system);
      expect(bloc.state.dnsMode, DnsMode.system);
      expect(bloc.state.coreMux, isFalse);
      expect(bloc.state.killSwitch, isFalse);

      bloc.add(const AppSettingsVpnPreferencesUpdated(coreMux: true));
      await expectLater(
        bloc.stream,
        emits(
          isA<AppSettingsState>().having((s) => s.coreMux, 'mux', isTrue),
        ),
      );

      bloc.add(
        const AppSettingsVpnPreferencesUpdated(dnsMode: DnsMode.doh),
      );
      await expectLater(
        bloc.stream,
        emits(
          isA<AppSettingsState>()
              .having((s) => s.dnsMode, 'dns', DnsMode.doh)
              .having((s) => s.coreMux, 'mux', isTrue),
        ),
      );

      final reloaded =
          AppSettingsBloc(prefs: await SharedPreferences.getInstance());
      addTearDown(reloaded.close);
      expect(reloaded.state.coreMux, isTrue);
      expect(reloaded.state.dnsMode, DnsMode.doh);
    });

    test('persists theme preference', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final bloc = AppSettingsBloc(prefs: prefs);
      addTearDown(bloc.close);

      bloc.add(
        const AppSettingsThemePreferenceUpdated(ThemePreference.dark),
      );
      await expectLater(
        bloc.stream,
        emits(
          isA<AppSettingsState>().having(
            (s) => s.themePreference,
            'theme',
            ThemePreference.dark,
          ),
        ),
      );

      final reloaded =
          AppSettingsBloc(prefs: await SharedPreferences.getInstance());
      addTearDown(reloaded.close);
      expect(reloaded.state.themePreference, ThemePreference.dark);
    });

    test('persists locale preference', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final bloc = AppSettingsBloc(prefs: prefs);
      addTearDown(bloc.close);

      expect(bloc.state.localePreference, LocalePreference.system);
      bloc.add(
        const AppSettingsLocalePreferenceUpdated(LocalePreference.ru),
      );
      await expectLater(
        bloc.stream,
        emits(
          isA<AppSettingsState>().having(
            (s) => s.localePreference,
            'locale',
            LocalePreference.ru,
          ),
        ),
      );

      final reloaded =
          AppSettingsBloc(prefs: await SharedPreferences.getInstance());
      addTearDown(reloaded.close);
      expect(reloaded.state.localePreference, LocalePreference.ru);
    });

    test('persists kill switch', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final bloc = AppSettingsBloc(prefs: prefs);
      addTearDown(bloc.close);

      bloc.add(const AppSettingsVpnPreferencesUpdated(killSwitch: true));
      await expectLater(
        bloc.stream,
        emits(
          isA<AppSettingsState>().having(
            (s) => s.killSwitch,
            'killSwitch',
            isTrue,
          ),
        ),
      );

      final reloaded =
          AppSettingsBloc(prefs: await SharedPreferences.getInstance());
      addTearDown(reloaded.close);
      expect(reloaded.state.killSwitch, isTrue);
    });

    test('persists SOCKS inbound settings', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final bloc = AppSettingsBloc(prefs: prefs);
      addTearDown(bloc.close);

      bloc.add(
        const AppSettingsVpnPreferencesUpdated(
          socksPort: 19080,
          socksUsername: 'alice',
          socksPassword: 'secret',
        ),
      );
      await expectLater(
        bloc.stream,
        emits(
          isA<AppSettingsState>()
              .having((s) => s.socksPort, 'port', 19080)
              .having((s) => s.socksUsername, 'user', 'alice')
              .having((s) => s.socksPassword, 'pass', 'secret'),
        ),
      );

      final reloaded =
          AppSettingsBloc(prefs: await SharedPreferences.getInstance());
      addTearDown(reloaded.close);
      expect(reloaded.state.socksPort, 19080);
      expect(reloaded.state.socksUsername, 'alice');
      expect(reloaded.state.socksPassword, 'secret');
    });

    test('persists onboarding completed', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final bloc = AppSettingsBloc(prefs: prefs);
      addTearDown(bloc.close);
      expect(bloc.state.onboardingCompleted, isFalse);
      bloc.add(const AppSettingsOnboardingCompleted());
      await expectLater(
        bloc.stream,
        emits(
          isA<AppSettingsState>().having(
            (s) => s.onboardingCompleted,
            'onboarding',
            isTrue,
          ),
        ),
      );
      final reloaded =
          AppSettingsBloc(prefs: await SharedPreferences.getInstance());
      addTearDown(reloaded.close);
      expect(reloaded.state.onboardingCompleted, isTrue);
    });
  });
}
