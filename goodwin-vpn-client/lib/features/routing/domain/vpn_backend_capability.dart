import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';

/// Which SOCKS/VPN core a share link targets.
enum VpnBackendKind {
  xray,
  hysteria,
  trustTunnel,
  unknown;

  bool get supportsXrayRouting => this == VpnBackendKind.xray;

  /// Domain / block / Xray Direct catch-all need Xray JSON.
  bool get supportsRichRouting => supportsXrayRouting;

  String get shortLabel => switch (this) {
        VpnBackendKind.xray => 'Xray',
        VpnBackendKind.hysteria => 'Hysteria2',
        VpnBackendKind.trustTunnel => 'TrustTunnel',
        VpnBackendKind.unknown => 'Unknown',
      };
}

VpnBackendKind vpnBackendKindForProfile(VpnProfile profile) => switch (profile) {
      XrayProfile() => VpnBackendKind.xray,
      HysteriaProfile() => VpnBackendKind.hysteria,
      TrustTunnelProfile() => VpnBackendKind.trustTunnel,
    };

VpnBackendKind vpnBackendKindForLink(String? link) {
  if (link == null || link.trim().isEmpty) return VpnBackendKind.unknown;
  try {
    return vpnBackendKindForProfile(const ShareLinkParser().parse(link.trim()));
  } catch (_) {
    return VpnBackendKind.unknown;
  }
}

/// User-facing capability note for Routes / Home.
String routingCapabilityBanner(VpnBackendKind kind) => switch (kind) {
      VpnBackendKind.xray =>
        'Xray profile: Global / Rules / Direct and domain rules apply on connect.',
      VpnBackendKind.hysteria =>
        'Hysteria2 profile: domain/block rules and Xray Direct are not applied. '
            'Use Global; Always-exclude CIDRs and IP-direct still merge into the TUN.',
      VpnBackendKind.trustTunnel =>
        'TrustTunnel: Rules direct domains/CIDRs become exclusions. '
            'Block is skipped (no plugin block). Direct mode is not applied. '
            'Always-exclude still merges. Per-app split is SOCKS-only. '
            'Kill Switch applies on the next TrustTunnel connect.',
      VpnBackendKind.unknown =>
        'Select or connect a profile to see which routing features apply.',
    };
