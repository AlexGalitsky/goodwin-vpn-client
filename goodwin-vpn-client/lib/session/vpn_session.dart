abstract interface class VpnSession {
  Future<void> start();

  /// Stop OS VPN (via slot) then the engine. Reverse of [start].
  Future<void> stop();

  /// Engine only — OS already dropped the TUN (revoke / failed establish).
  void stopEngine();

  String get connectedMessage;

  String? get engineVersion;
}
