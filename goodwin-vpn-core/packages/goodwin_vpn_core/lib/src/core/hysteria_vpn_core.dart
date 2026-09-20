import '../ffi/libhysteria.dart';
import 'vpn_core.dart';

/// Hysteria 2 backend via `libhysteria` c-shared.
class HysteriaVpnCore implements VpnCore {
  HysteriaVpnCore(this._lib);

  final LibHysteria _lib;
  String? _activeId;

  @override
  String get id => 'hysteria2';

  @override
  String? get engineVersion {
    try {
      return _lib.version();
    } catch (_) {
      return null;
    }
  }

  @override
  bool get isRunning {
    final id = _activeId;
    if (id == null) return false;
    return _lib.isStarted(id);
  }

  @override
  void start({required String instanceId, required String configJson}) {
    final result = _lib.start(instanceId, configJson);
    if (!result.ok) {
      throw StateError('Hysteria Start failed (${result.status}): ${result.body}');
    }
    if (!_lib.isStarted(instanceId)) {
      throw StateError('Hysteria Start ok but IsStarted=false');
    }
    _activeId = instanceId;
  }

  @override
  void stop(String instanceId) {
    _lib.stop(instanceId);
    if (_activeId == instanceId) _activeId = null;
  }

  @override
  bool isInstanceRunning(String instanceId) => _lib.isStarted(instanceId);

  @override
  void adopt(String instanceId) {
    if (!_lib.isStarted(instanceId)) {
      throw StateError('Hysteria instance $instanceId is not running');
    }
    _activeId = instanceId;
  }
}
