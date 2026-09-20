import 'package:flutter/material.dart';

/// Persisted appearance. Light and dark [ThemeData] always exist; this picks which to show.
enum ThemePreference {
  system,
  light,
  dark;

  String get storageValue => name;

  ThemeMode get themeMode => switch (this) {
        ThemePreference.system => ThemeMode.system,
        ThemePreference.light => ThemeMode.light,
        ThemePreference.dark => ThemeMode.dark,
      };

  static ThemePreference parse(String? raw) => switch (raw) {
        'light' => ThemePreference.light,
        'dark' => ThemePreference.dark,
        _ => ThemePreference.system,
      };
}
