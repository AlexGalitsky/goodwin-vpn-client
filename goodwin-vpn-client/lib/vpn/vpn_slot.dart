import 'system_tunnel.dart';

enum VpnSlotOwner { none, socksTun, trustTunnel }

/// Exclusive owner of the Android VPN interface.
///
/// [release] always tears down both possible holders and waits until the OS
/// reports they are gone. Callers must not sleep() to "make room" for the next VPN.
class VpnSlot {
  VpnSlot({
    required this.systemTunnel,
    required this.ownedEngine,
  });

  final SystemTunnel systemTunnel;
  final OwnedVpnEngine ownedEngine;

  VpnSlotOwner _owner = VpnSlotOwner.none;

  VpnSlotOwner get owner => _owner;

  void mark(VpnSlotOwner owner) {
    _owner = owner;
  }

  /// Stop TrustTunnel plugin and our VpnService; wait until both released.
  Future<void> release({
    Duration timeout = const Duration(seconds: 15),
  }) async {
    try {
      await ownedEngine.stop(timeout: timeout);
    } finally {
      await systemTunnel.stop();
    }
    _owner = VpnSlotOwner.none;
  }
}
