import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/config/dns_mode.dart';
import '../../../../core/config/locale_preference.dart';
import '../../../../core/config/theme_preference.dart';
import '../../../../core/config/ui_mode.dart';

sealed class AppSettingsEvent {
  const AppSettingsEvent();
}

final class AppSettingsLoadRequested extends AppSettingsEvent {
  const AppSettingsLoadRequested();
}

final class AppSettingsUiModeUpdated extends AppSettingsEvent {
  const AppSettingsUiModeUpdated(this.uiMode);
  final UiMode uiMode;
}

final class AppSettingsThemePreferenceUpdated extends AppSettingsEvent {
  const AppSettingsThemePreferenceUpdated(this.themePreference);
  final ThemePreference themePreference;
}

final class AppSettingsVpnPreferencesUpdated extends AppSettingsEvent {
  const AppSettingsVpnPreferencesUpdated({
    this.dnsMode,
    this.dnsCustom,
    this.clearDnsCustom = false,
    this.coreMux,
    this.coreFragment,
    this.killSwitch,
    this.socksPort,
    this.socksUsername,
    this.socksPassword,
    this.clearSocksUsername = false,
    this.clearSocksPassword = false,
  });

  final DnsMode? dnsMode;
  final String? dnsCustom;
  final bool clearDnsCustom;
  final bool? coreMux;
  final bool? coreFragment;
  final bool? killSwitch;
  final int? socksPort;
  final String? socksUsername;
  final String? socksPassword;
  final bool clearSocksUsername;
  final bool clearSocksPassword;
}

final class AppSettingsLocalePreferenceUpdated extends AppSettingsEvent {
  const AppSettingsLocalePreferenceUpdated(this.localePreference);
  final LocalePreference localePreference;
}

final class AppSettingsOnboardingCompleted extends AppSettingsEvent {
  const AppSettingsOnboardingCompleted();
}

final class AppSettingsVpnExplainerSeen extends AppSettingsEvent {
  const AppSettingsVpnExplainerSeen();
}

final class AppSettingsCameraExplainerSeen extends AppSettingsEvent {
  const AppSettingsCameraExplainerSeen();
}

class AppSettingsState extends Equatable {
  const AppSettingsState({
    this.uiMode = UiMode.standard,
    this.themePreference = ThemePreference.system,
    this.localePreference = LocalePreference.system,
    this.dnsMode = DnsMode.system,
    this.dnsCustom,
    this.coreMux = false,
    this.coreFragment = false,
    this.killSwitch = false,
    this.socksPort = 10808,
    this.socksUsername = '',
    this.socksPassword = '',
    this.socksSessionUsername = '',
    this.socksSessionPassword = '',
    this.onboardingCompleted = false,
    this.vpnExplainerSeen = false,
    this.cameraExplainerSeen = false,
  });

  final UiMode uiMode;
  final ThemePreference themePreference;
  final LocalePreference localePreference;
  final DnsMode dnsMode;
  final String? dnsCustom;
  final bool coreMux;
  final bool coreFragment;
  final bool killSwitch;
  final int socksPort;
  final String socksUsername;
  final String socksPassword;
  final String socksSessionUsername;
  final String socksSessionPassword;
  final bool onboardingCompleted;
  final bool vpnExplainerSeen;
  final bool cameraExplainerSeen;

  AppSettingsState copyWith({
    UiMode? uiMode,
    ThemePreference? themePreference,
    LocalePreference? localePreference,
    DnsMode? dnsMode,
    String? dnsCustom,
    bool? coreMux,
    bool? coreFragment,
    bool? killSwitch,
    int? socksPort,
    String? socksUsername,
    String? socksPassword,
    String? socksSessionUsername,
    String? socksSessionPassword,
    bool? onboardingCompleted,
    bool? vpnExplainerSeen,
    bool? cameraExplainerSeen,
    bool clearDnsCustom = false,
    bool clearSocksUsername = false,
    bool clearSocksPassword = false,
  }) {
    return AppSettingsState(
      uiMode: uiMode ?? this.uiMode,
      themePreference: themePreference ?? this.themePreference,
      localePreference: localePreference ?? this.localePreference,
      dnsMode: dnsMode ?? this.dnsMode,
      dnsCustom: clearDnsCustom ? null : (dnsCustom ?? this.dnsCustom),
      coreMux: coreMux ?? this.coreMux,
      coreFragment: coreFragment ?? this.coreFragment,
      killSwitch: killSwitch ?? this.killSwitch,
      socksPort: socksPort ?? this.socksPort,
      socksUsername: clearSocksUsername
          ? ''
          : (socksUsername ?? this.socksUsername),
      socksPassword: clearSocksPassword
          ? ''
          : (socksPassword ?? this.socksPassword),
      socksSessionUsername:
          socksSessionUsername ?? this.socksSessionUsername,
      socksSessionPassword:
          socksSessionPassword ?? this.socksSessionPassword,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      vpnExplainerSeen: vpnExplainerSeen ?? this.vpnExplainerSeen,
      cameraExplainerSeen: cameraExplainerSeen ?? this.cameraExplainerSeen,
    );
  }

  @override
  List<Object?> get props => [
        uiMode,
        themePreference,
        localePreference,
        dnsMode,
        dnsCustom,
        coreMux,
        coreFragment,
        killSwitch,
        socksPort,
        socksUsername,
        socksPassword,
        socksSessionUsername,
        socksSessionPassword,
        onboardingCompleted,
        vpnExplainerSeen,
        cameraExplainerSeen,
      ];
}

/// App-scoped settings: UiMode + VPN prefs applied on connect (DNS / mux / fragment / Kill Switch).
class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  AppSettingsBloc({required SharedPreferences prefs})
      : _prefs = prefs,
        super(_read(prefs)) {
    on<AppSettingsLoadRequested>(_onLoad);
    on<AppSettingsUiModeUpdated>(_onUiMode);
    on<AppSettingsThemePreferenceUpdated>(_onThemePreference);
    on<AppSettingsLocalePreferenceUpdated>(_onLocalePreference);
    on<AppSettingsVpnPreferencesUpdated>(_onVpnPreferences);
    on<AppSettingsOnboardingCompleted>(_onOnboardingCompleted);
    on<AppSettingsVpnExplainerSeen>(_onVpnExplainerSeen);
    on<AppSettingsCameraExplainerSeen>(_onCameraExplainerSeen);
  }

  static const _uiModeKey = 'ui_mode';
  static const _themePreferenceKey = 'theme_preference';
  static const _localePreferenceKey = 'locale_preference';
  static const _dnsModeKey = 'vpn_dns_mode';
  static const _dnsCustomKey = 'vpn_dns_custom';
  static const _coreMuxKey = 'vpn_core_mux';
  static const _coreFragmentKey = 'vpn_core_fragment';
  static const _killSwitchKey = 'vpn_kill_switch';
  static const _socksPortKey = 'vpn_socks_port';
  static const _socksUsernameKey = 'vpn_socks_username';
  static const _socksPasswordKey = 'vpn_socks_password';
  static const _socksSessionUserKey = 'vpn_socks_session_user';
  static const _socksSessionPassKey = 'vpn_socks_session_pass';
  static const _onboardingKey = 'onboarding_completed';
  static const _vpnExplainerKey = 'vpn_explainer_seen';
  static const _cameraExplainerKey = 'camera_explainer_seen';

  final SharedPreferences _prefs;

  static AppSettingsState _read(SharedPreferences prefs) {
    return AppSettingsState(
      uiMode: UiMode.parse(prefs.getString(_uiModeKey)),
      themePreference:
          ThemePreference.parse(prefs.getString(_themePreferenceKey)),
      localePreference:
          LocalePreference.parse(prefs.getString(_localePreferenceKey)),
      dnsMode: DnsMode.parse(prefs.getString(_dnsModeKey)),
      dnsCustom: prefs.getString(_dnsCustomKey),
      coreMux: prefs.getBool(_coreMuxKey) ?? false,
      coreFragment: prefs.getBool(_coreFragmentKey) ?? false,
      killSwitch: prefs.getBool(_killSwitchKey) ?? false,
      socksPort: _readPort(prefs.getInt(_socksPortKey)),
      socksUsername: prefs.getString(_socksUsernameKey) ?? '',
      socksPassword: prefs.getString(_socksPasswordKey) ?? '',
      socksSessionUsername: prefs.getString(_socksSessionUserKey) ?? '',
      socksSessionPassword: prefs.getString(_socksSessionPassKey) ?? '',
      onboardingCompleted: prefs.getBool(_onboardingKey) ?? false,
      vpnExplainerSeen: prefs.getBool(_vpnExplainerKey) ?? false,
      cameraExplainerSeen: prefs.getBool(_cameraExplainerKey) ?? false,
    );
  }

  static int _readPort(int? raw) {
    if (raw == null || raw < 1024 || raw > 65535) return 10808;
    return raw;
  }

  Future<void> _onLoad(
    AppSettingsLoadRequested event,
    Emitter<AppSettingsState> emit,
  ) async {
    emit(_read(_prefs));
  }

  Future<void> _onUiMode(
    AppSettingsUiModeUpdated event,
    Emitter<AppSettingsState> emit,
  ) async {
    await _prefs.setString(_uiModeKey, event.uiMode.storageValue);
    emit(state.copyWith(uiMode: event.uiMode));
  }

  Future<void> _onThemePreference(
    AppSettingsThemePreferenceUpdated event,
    Emitter<AppSettingsState> emit,
  ) async {
    await _prefs.setString(
      _themePreferenceKey,
      event.themePreference.storageValue,
    );
    emit(state.copyWith(themePreference: event.themePreference));
  }

  Future<void> _onLocalePreference(
    AppSettingsLocalePreferenceUpdated event,
    Emitter<AppSettingsState> emit,
  ) async {
    await _prefs.setString(
      _localePreferenceKey,
      event.localePreference.storageValue,
    );
    emit(state.copyWith(localePreference: event.localePreference));
  }

  Future<void> _onVpnPreferences(
    AppSettingsVpnPreferencesUpdated event,
    Emitter<AppSettingsState> emit,
  ) async {
    final next = state.copyWith(
      dnsMode: event.dnsMode,
      dnsCustom: event.dnsCustom,
      clearDnsCustom: event.clearDnsCustom,
      coreMux: event.coreMux,
      coreFragment: event.coreFragment,
      killSwitch: event.killSwitch,
      socksPort: event.socksPort,
      socksUsername: event.socksUsername,
      socksPassword: event.socksPassword,
      clearSocksUsername: event.clearSocksUsername,
      clearSocksPassword: event.clearSocksPassword,
    );
    await _prefs.setString(_dnsModeKey, next.dnsMode.storageValue);
    if (next.dnsCustom == null || next.dnsCustom!.isEmpty) {
      await _prefs.remove(_dnsCustomKey);
    } else {
      await _prefs.setString(_dnsCustomKey, next.dnsCustom!);
    }
    await _prefs.setBool(_coreMuxKey, next.coreMux);
    await _prefs.setBool(_coreFragmentKey, next.coreFragment);
    await _prefs.setBool(_killSwitchKey, next.killSwitch);
    await _prefs.setInt(_socksPortKey, next.socksPort);
    if (next.socksUsername.isEmpty) {
      await _prefs.remove(_socksUsernameKey);
    } else {
      await _prefs.setString(_socksUsernameKey, next.socksUsername);
    }
    if (next.socksPassword.isEmpty) {
      await _prefs.remove(_socksPasswordKey);
    } else {
      await _prefs.setString(_socksPasswordKey, next.socksPassword);
    }
    emit(next);
  }

  Future<void> _onOnboardingCompleted(
    AppSettingsOnboardingCompleted event,
    Emitter<AppSettingsState> emit,
  ) async {
    await _prefs.setBool(_onboardingKey, true);
    emit(state.copyWith(onboardingCompleted: true));
  }

  Future<void> _onVpnExplainerSeen(
    AppSettingsVpnExplainerSeen event,
    Emitter<AppSettingsState> emit,
  ) async {
    await _prefs.setBool(_vpnExplainerKey, true);
    emit(state.copyWith(vpnExplainerSeen: true));
  }

  Future<void> _onCameraExplainerSeen(
    AppSettingsCameraExplainerSeen event,
    Emitter<AppSettingsState> emit,
  ) async {
    await _prefs.setBool(_cameraExplainerKey, true);
    emit(state.copyWith(cameraExplainerSeen: true));
  }

  Future<void> rememberSocksSession(String username, String password) async {
    await _prefs.setString(_socksSessionUserKey, username);
    await _prefs.setString(_socksSessionPassKey, password);
    emit(
      state.copyWith(
        socksSessionUsername: username,
        socksSessionPassword: password,
      ),
    );
  }
}
