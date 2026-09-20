import 'dart:math';

import '../domain/models/routing_models.dart';
import '../domain/repositories/vpn_routing_engine.dart';

/// In-memory routing policy (tests / fallback). Prefer [PrefsVpnRoutingEngine].
class StubVpnRoutingEngine implements VpnRoutingEngine {
  RoutingSnapshot _snapshot = const RoutingSnapshot();
  final _random = Random();

  @override
  Future<RoutingSnapshot> load() async => _snapshot;

  @override
  Future<RoutingSnapshot> setMode(RoutingMode mode) async {
    _snapshot = _snapshot.copyWith(mode: mode);
    return _snapshot;
  }

  @override
  Future<RoutingSnapshot> setPreset({
    required RoutingPresetId id,
    required bool enabled,
  }) async {
    final next = {..._snapshot.enabledPresets};
    if (enabled) {
      next.add(id);
    } else {
      next.remove(id);
    }
    _snapshot = _snapshot.copyWith(enabledPresets: next);
    return _snapshot;
  }

  @override
  Future<RoutingSnapshot> addRule({
    required String matcher,
    required RoutingAction action,
  }) async {
    final trimmed = matcher.trim();
    if (trimmed.isEmpty) return _snapshot;
    final rule = RoutingRule(
      id: 'rule_${_random.nextInt(1 << 32)}',
      matcher: trimmed,
      action: action,
    );
    _snapshot = _snapshot.copyWith(
      customRules: [..._snapshot.customRules, rule],
    );
    return _snapshot;
  }

  @override
  Future<RoutingSnapshot> removeRule(String id) async {
    _snapshot = _snapshot.copyWith(
      customRules: [
        for (final rule in _snapshot.customRules)
          if (rule.id != id) rule,
      ],
    );
    return _snapshot;
  }

  @override
  Future<void> reset() async {
    _snapshot = const RoutingSnapshot();
  }
}
