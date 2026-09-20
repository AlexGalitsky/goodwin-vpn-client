import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../../l10n/app_localizations.dart';

/// Short Settings row. Long Always-on / on-demand copy lives in sheets.
String killSwitchSettingsSubtitle(
  AppLocalizations l10n, {
  required bool isIos,
}) {
  if (isIos) return l10n.killSwitchSubtitleIos;
  return l10n.killSwitchSubtitleAndroid;
}

/// In-app toggle is not Android Always-on. Only ON after the user actually
/// left for system VPN settings and confirmed the OS switches.
bool androidKillSwitchShouldTurnOn({
  required bool returnedFromSettings,
  required bool? confirmedAlwaysOn,
}) =>
    returnedFromSettings && confirmedAlwaysOn == true;

/// True when [leave] sent the app to background and it came back.
///
/// Opening Android VPN settings returns from the platform channel immediately.
/// Confirming Always-on before that resume is how the toggle used to lie ON.
Future<bool> waitUntilAppReturned({
  required Future<void> Function() leave,
  Duration stillHere = const Duration(milliseconds: 700),
  Duration timeout = const Duration(minutes: 3),
}) async {
  final returned = Completer<bool>();
  var left = false;
  final listener = AppLifecycleListener(
    onInactive: () => left = true,
    onHide: () => left = true,
    onPause: () => left = true,
    onResume: () {
      if (!returned.isCompleted) returned.complete(left);
    },
  );
  try {
    await leave();
    await Future<void>.delayed(stillHere);
    if (!left &&
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
      return false;
    }
    if (returned.isCompleted) return await returned.future;
    return await returned.future.timeout(timeout, onTimeout: () => false);
  } finally {
    listener.dispose();
  }
}
