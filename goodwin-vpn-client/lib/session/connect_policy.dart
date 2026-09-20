import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';

import 'socks_inbound.dart';

/// Policy applied at connect (routing + Xray build options).
class ResolvedConnectPolicy {
  const ResolvedConnectPolicy({
    this.xrayOptions = const XrayBuildOptions(),
    this.extraExcludeRoutes = const [],
    this.extraDisallowedPackages = const [],
    this.tunDnsServers = const [],
    this.logNotes = const [],
    this.socks = SocksInbound.test,
  });

  /// Used only for [XrayProfile] JSON; ignored by Hy2/TT cores.
  final XrayBuildOptions xrayOptions;

  /// Local SOCKS5 listen (always password-auth). Ignored by TrustTunnel.
  final SocksInbound socks;

  /// IP/CIDR from Rules `direct` — union with Home excludes (D6).
  /// TrustTunnel also receives direct **domains** here (`*.host`); Hy2/Xray
  /// TUN parsers skip non-CIDR entries.
  final List<String> extraExcludeRoutes;

  /// Android per-app bypass (Protect banking + user picks).
  final List<String> extraDisallowedPackages;

  /// OS TUN DNS servers (IPs only). Empty → platform defaults.
  final List<String> tunDnsServers;

  final List<String> logNotes;
}

/// Loads routing/settings and compiles them for a profile (no I/O beyond prefs).
abstract interface class ConnectPolicyResolver {
  Future<ResolvedConnectPolicy> resolve(
    VpnProfile profile, {
    String? shareLink,
    bool reuseSocksSession = false,
  });
}

/// Tests / default: Global proxy, no extras.
class PassthroughConnectPolicyResolver implements ConnectPolicyResolver {
  const PassthroughConnectPolicyResolver();

  @override
  Future<ResolvedConnectPolicy> resolve(
    VpnProfile profile, {
    String? shareLink,
    bool reuseSocksSession = false,
  }) async {
    return const ResolvedConnectPolicy();
  }
}
