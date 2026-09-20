import '../ffi/libxray.dart';
import 'vpn_core.dart';

/// Xray backend via xray-cshare (`LibXray`).
class XrayVpnCore implements VpnCore {
  XrayVpnCore(this._lib);

  final LibXray _lib;
  String? _activeId;

  @override
  String get id => 'xray';

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
      throw StateError('Xray Start failed (${result.status}): ${result.body}');
    }
    if (!_lib.isStarted(instanceId)) {
      throw StateError('Xray Start ok but IsStarted=false');
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
      throw StateError('Xray instance $instanceId is not running');
    }
    _activeId = instanceId;
  }
}
