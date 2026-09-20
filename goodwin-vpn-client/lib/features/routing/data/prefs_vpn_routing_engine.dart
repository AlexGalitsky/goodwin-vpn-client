import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/models/routing_models.dart';
import '../domain/repositories/vpn_routing_engine.dart';

/// Persists [RoutingSnapshot] in SharedPreferences (survives app restart).
class PrefsVpnRoutingEngine implements VpnRoutingEngine {
  PrefsVpnRoutingEngine(this._prefs);

  static const storageKey = 'vpn_routing_snapshot';

  final SharedPreferences _prefs;
  final _random = Random();

  RoutingSnapshot _read() =>
      RoutingSnapshot.decode(_prefs.getString(storageKey));

  Future<RoutingSnapshot> _write(RoutingSnapshot snapshot) async {
    await _prefs.setString(storageKey, snapshot.encode());
    return snapshot;
  }

  @override
  Future<RoutingSnapshot> load() async => _read();

  @override
  Future<RoutingSnapshot> setMode(RoutingMode mode) {
    return _write(_read().copyWith(mode: mode));
  }

  @override
  Future<RoutingSnapshot> setPreset({
    required RoutingPresetId id,
    required bool enabled,
  }) {
    final current = _read();
    final next = {...current.enabledPresets};
    if (enabled) {
      next.add(id);
    } else {
      next.remove(id);
    }
    return _write(current.copyWith(enabledPresets: next));
  }

  @override
  Future<RoutingSnapshot> addRule({
    required String matcher,
    required RoutingAction action,
  }) {
    final trimmed = matcher.trim();
    final current = _read();
    if (trimmed.isEmpty) return Future.value(current);
    final rule = RoutingRule(
      id: 'rule_${_random.nextInt(1 << 32)}',
      matcher: trimmed,
      action: action,
    );
    return _write(
      current.copyWith(customRules: [...current.customRules, rule]),
    );
  }

  @override
  Future<RoutingSnapshot> removeRule(String id) {
    final current = _read();
    return _write(
      current.copyWith(
        customRules: [
          for (final rule in current.customRules)
            if (rule.id != id) rule,
        ],
      ),
    );
  }

  @override
  Future<void> reset() async {
    await _prefs.remove(storageKey);
  }
}
