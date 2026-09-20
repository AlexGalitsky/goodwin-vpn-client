import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';

/// VpnCore stub for iOS: SOCKS engine runs inside SocksTunnel.appex (no UI FFI).
class ExtensionHostedVpnCore implements VpnCore {
  ExtensionHostedVpnCore(this.id);

  @override
  final String id;

  @override
  String? get engineVersion => null;

  bool _adopted = false;

  @override
  bool get isRunning => _adopted;

  @override
  void start({required String instanceId, required String configJson}) {
    _adopted = true;
  }

  @override
  void stop(String instanceId) {
    _adopted = false;
  }

  @override
  bool isInstanceRunning(String instanceId) => _adopted;

  @override
  void adopt(String instanceId) {
    _adopted = true;
  }
}
