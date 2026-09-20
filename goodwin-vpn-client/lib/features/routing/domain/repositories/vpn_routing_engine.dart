import '../models/routing_models.dart';

/// Port for routing / split-tunnel policy (persist + later core apply).
abstract interface class VpnRoutingEngine {
  Future<RoutingSnapshot> load();

  Future<RoutingSnapshot> setMode(RoutingMode mode);

  Future<RoutingSnapshot> setPreset({
    required RoutingPresetId id,
    required bool enabled,
  });

  Future<RoutingSnapshot> addRule({
    required String matcher,
    required RoutingAction action,
  });

  Future<RoutingSnapshot> removeRule(String id);

  Future<void> reset();
}
