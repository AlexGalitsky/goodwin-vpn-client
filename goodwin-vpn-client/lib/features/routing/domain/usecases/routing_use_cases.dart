import '../models/routing_models.dart';
import '../repositories/vpn_routing_engine.dart';

class LoadRoutingSnapshotUseCase {
  const LoadRoutingSnapshotUseCase(this._engine);

  final VpnRoutingEngine _engine;

  Future<RoutingSnapshot> call() => _engine.load();
}

class SetRoutingModeUseCase {
  const SetRoutingModeUseCase(this._engine);

  final VpnRoutingEngine _engine;

  Future<RoutingSnapshot> call(RoutingMode mode) => _engine.setMode(mode);
}

class SetRoutingPresetUseCase {
  const SetRoutingPresetUseCase(this._engine);

  final VpnRoutingEngine _engine;

  Future<RoutingSnapshot> call({
    required RoutingPresetId id,
    required bool enabled,
  }) {
    return _engine.setPreset(id: id, enabled: enabled);
  }
}

class AddRoutingRuleUseCase {
  const AddRoutingRuleUseCase(this._engine);

  final VpnRoutingEngine _engine;

  Future<RoutingSnapshot> call({
    required String matcher,
    required RoutingAction action,
  }) {
    return _engine.addRule(matcher: matcher, action: action);
  }
}

class RemoveRoutingRuleUseCase {
  const RemoveRoutingRuleUseCase(this._engine);

  final VpnRoutingEngine _engine;

  Future<RoutingSnapshot> call(String id) => _engine.removeRule(id);
}

class ResetRoutingUseCase {
  const ResetRoutingUseCase(this._engine);

  final VpnRoutingEngine _engine;

  Future<void> call() => _engine.reset();
}
