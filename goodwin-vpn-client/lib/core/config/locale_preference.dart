import 'package:flutter/material.dart';

/// Persisted UI language. System follows the OS.
enum LocalePreference {
  system,
  en,
  ru,
  zh,
  ar,
  fa,
  id,
  tr,
  de,
  fr,
  es,
  pt,
  it,
  ja,
  ko,
  hi;

  String get storageValue => name;

  /// Native autonym; [system] is labeled via l10n.
  String get nativeLabel => switch (this) {
        LocalePreference.system => '',
        LocalePreference.en => 'English',
        LocalePreference.ru => 'Русский',
        LocalePreference.zh => '简体中文',
        LocalePreference.ar => 'العربية',
        LocalePreference.fa => 'فارسی',
        LocalePreference.id => 'Bahasa Indonesia',
        LocalePreference.tr => 'Türkçe',
        LocalePreference.de => 'Deutsch',
        LocalePreference.fr => 'Français',
        LocalePreference.es => 'Español',
        LocalePreference.pt => 'Português (Brasil)',
        LocalePreference.it => 'Italiano',
        LocalePreference.ja => '日本語',
        LocalePreference.ko => '한국어',
        LocalePreference.hi => 'हिन्दी',
      };

  /// `null` lets [MaterialApp] use the device locale.
  Locale? get locale =>
      this == LocalePreference.system ? null : Locale(name);

  static LocalePreference parse(String? raw) {
    if (raw == null || raw.isEmpty || raw == 'system') {
      return LocalePreference.system;
    }
    for (final value in LocalePreference.values) {
      if (value != LocalePreference.system && value.name == raw) {
        return value;
      }
    }
    return LocalePreference.system;
  }
}

Locale? localeResolutionCallback(
  Locale? locale,
  Iterable<Locale> supportedLocales,
) {
  if (locale == null) {
    return const Locale('en');
  }
  for (final supported in supportedLocales) {
    if (supported.languageCode == locale.languageCode) {
      return supported;
    }
  }
  return const Locale('en');
}
