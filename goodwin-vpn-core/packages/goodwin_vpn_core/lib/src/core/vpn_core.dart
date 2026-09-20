/// SOCKS backends (Xray, Hysteria). TrustTunnel is not a VpnCore.
abstract interface class VpnCore {
  /// Stable backend id, e.g. `xray`, `hysteria2`, `trusttunnel`.
  String get id;

  /// Human-readable embedded engine version if available.
  String? get engineVersion;

  bool get isRunning;

  /// Start proxy (typically local SOCKS). Platform TUN is outside this interface.
  void start({
    required String instanceId,
    required String configJson,
  });

  void stop(String instanceId);

  /// Native instance still running (Dart object may be new after Flutter restart).
  bool isInstanceRunning(String instanceId);

  /// Bind this wrapper to an already-started native instance.
  void adopt(String instanceId);
}
