import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';

import '../vpn/system_tunnel.dart';
import '../vpn/vpn_slot.dart';
import 'tunnel_elevation.dart';
import 'vpn_session.dart';

/// Official TrustTunnel plugin VpnService — not a SOCKS engine.
class TrustTunnelSession implements VpnSession {
  TrustTunnelSession({
    required this.profile,
    required this.slot,
    required this.owned,
    required this.log,
    required this.tunnel,
    this.excludeRoutes = const [],
    this.killSwitch = false,
  });

  final TrustTunnelProfile profile;
  final VpnSlot slot;
  final OwnedVpnEngine owned;
  final void Function(String line) log;
  final SystemTunnel tunnel;
  final List<String> excludeRoutes;
  final bool killSwitch;

  @override
  String? get engineVersion => 'trusttunnel';

  @override
  String get connectedMessage => 'TrustTunnel VPN · ${profile.name}';

  @override
  Future<void> start() async {
    if (!owned.isSupported) {
      throw StateError('TrustTunnel is not supported on this platform');
    }
    // Windows: fail fast with UAC banner instead of waiting for vpn_easy timeout.
    if (tunnel.isSupported && tunnel.needsElevationOnPrepare) {
      log('request system VPN permission (TrustTunnel)');
      final granted = await tunnel.prepare();
      if (!granted) {
        throw const TunnelElevationRequired();
      }
    }
    log(
      killSwitch
          ? 'start TrustTunnel (plugin owns system VPN, Kill Switch on)'
          : 'start TrustTunnel (plugin owns system VPN)',
    );
    await owned.start(
      profile,
      excludeRoutes: excludeRoutes,
      killSwitch: killSwitch,
    );
    slot.mark(VpnSlotOwner.trustTunnel);
    log('connected — TrustTunnel system VPN');
  }

  /// Flutter restarted; plugin VpnService is already up.
  void attachExisting() {
    slot.mark(VpnSlotOwner.trustTunnel);
    log('reattached TrustTunnel');
  }

  @override
  Future<void> stop() async {
    await slot.release();
  }

  @override
  void stopEngine() {
    // Plugin stop is async and needs [OwnedVpnEngine.stop]; revoke of *our*
    // VpnService does not apply. Disconnect path uses [stop].
  }
}
