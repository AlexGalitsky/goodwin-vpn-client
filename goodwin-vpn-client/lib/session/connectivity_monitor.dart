import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Observes default-route changes (Wi‑Fi ↔ LTE, offline ↔ online).
abstract interface class ConnectivityMonitor {
  Stream<List<ConnectivityResult>> get onChanged;

  Future<List<ConnectivityResult>> checkConnectivity();
}

class ConnectivityPlusMonitor implements ConnectivityMonitor {
  ConnectivityPlusMonitor({Connectivity? plugin}) : _plugin = plugin ?? Connectivity();

  final Connectivity _plugin;

  @override
  Stream<List<ConnectivityResult>> get onChanged => _plugin.onConnectivityChanged;

  @override
  Future<List<ConnectivityResult>> checkConnectivity() => _plugin.checkConnectivity();
}

/// Physical transports we reconnect on (Wi‑Fi ↔ LTE, offline ↔ online).
///
/// Apple reports our own Packet Tunnel as [ConnectivityResult.other] (and
/// sometimes [ConnectivityResult.vpn]). Including those in the key flips the
/// snapshot when NE comes up and causes an endless connected→connecting loop.
bool _isPhysicalConnectivity(ConnectivityResult r) {
  return switch (r) {
    ConnectivityResult.wifi ||
    ConnectivityResult.mobile ||
    ConnectivityResult.ethernet ||
    ConnectivityResult.satellite ||
    ConnectivityResult.none =>
      true,
    ConnectivityResult.vpn ||
    ConnectivityResult.other ||
    ConnectivityResult.bluetooth =>
      false,
  };
}

/// Stable key for comparing connectivity snapshots (order-independent).
String connectivityKey(List<ConnectivityResult> results) {
  if (results.isEmpty) return 'none';
  final physical = [
    for (final r in results)
      if (_isPhysicalConnectivity(r)) r.name,
  ]..sort();
  // Only VPN/other/bluetooth — treat as "still online", not a path change.
  if (physical.isEmpty) return 'online';
  return physical.join('+');
}

bool connectivityOnline(List<ConnectivityResult> results) {
  return results.any((r) => r != ConnectivityResult.none);
}
