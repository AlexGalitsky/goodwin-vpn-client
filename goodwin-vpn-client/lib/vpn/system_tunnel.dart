import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';

/// Lifecycle of our Android VpnService (hev). TrustTunnel uses a different owner.
enum SystemTunnelKind { established, failed, revoked, stopped }

class SystemTunnelEvent {
  const SystemTunnelEvent(this.kind, {this.message});

  final SystemTunnelKind kind;
  final String? message;

  @override
  String toString() => 'SystemTunnelEvent($kind${message == null ? '' : ', $message'})';
}

/// TUN owned by this app (hev → local SOCKS). Not TrustTunnel.
abstract interface class SystemTunnel {
  bool get isSupported;

  /// True when [prepare] may fail until the user elevates (Windows admin).
  bool get needsElevationOnPrepare => false;

  /// Android 13+ `excludeRoute` (and Apple NE excludes). Android 12 and older
  /// cannot carve an IPv6 /128 out of `::/0` — IPv6-only VPS must fail connect.
  bool get supportsIpv6RouteExclude => true;

  Stream<SystemTunnelEvent> get events;

  Future<bool> prepare();

  /// Relaunch elevated (UAC). No-op on platforms that do not need it.
  Future<bool> requestElevation() async => false;

  /// Starts the OS VPN and waits until [SystemTunnelKind.established] or throws on failed/timeout.
  ///
  /// [bypassHost] — VPN server hostname/IP for anti-loop routing (Windows).
  /// [excludeRoutes] — extra CIDR/IP prefixes routed via the physical gateway (P-U2 / RDP-safe).
  /// [dnsServers] — TUN DNS IPs (empty → platform defaults 1.1.1.1 / 8.8.8.8).
  /// [engineId] / [configJson] — iOS SOCKS NE hosts the core inside the appex (no UI FFI).
  /// [disallowedPackages] — Android per-app split (apps that skip the TUN).
  /// [killSwitch] — iOS: includeAllNetworks + on-demand. Android: ignored
  /// (Always-on is an OS setting the app cannot flip).
  /// [socksUsername] / [socksPassword] — hev RFC1929 to local Xray/Hy2.
  Future<void> start({
    String socksHost = '127.0.0.1',
    int socksPort = 10808,
    String? socksUsername,
    String? socksPassword,
    String? bypassHost,
    List<String> excludeRoutes = const [],
    List<String> dnsServers = const [],
    String? engineId,
    String? configJson,
    List<String> disallowedPackages = const [],
    bool killSwitch = false,
  });

  /// Stops the OS VPN and waits until [SystemTunnelKind.stopped] (or timeout).
  Future<void> stop();

  /// Whether our hev TUN is up (same process). False after a full process death.
  Future<bool> isEstablished();

  Future<String?> nativeLibraryDir();
}

/// Plugin-owned VpnService (TrustTunnel). Not a SOCKS engine.
abstract interface class OwnedVpnEngine {
  bool get isSupported;

  /// [killSwitch] arms plugin leak protection for this session only.
  /// [stop] must disarm it before tearing down so hev can take the slot.
  Future<void> start(
    TrustTunnelProfile profile, {
    List<String> excludeRoutes = const [],
    bool killSwitch = false,
  });

  Future<void> stop({Duration timeout = const Duration(seconds: 15)});

  /// Plugin reports connected (survives Flutter restarts if the OS VPN is still up).
  Future<bool> isConnected();

  /// OS dropped the plugin VPN while we thought we were up.
  /// Disconnects we initiate ourselves are not emitted.
  Stream<void> get unexpectedDrops;
}
