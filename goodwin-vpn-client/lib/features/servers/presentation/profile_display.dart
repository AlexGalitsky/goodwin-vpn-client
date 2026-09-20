import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';

import '../../../session/saved_profile.dart';

String profileDisplayName(SavedProfile profile) {
  final custom = profile.name.trim();
  if (custom.isNotEmpty) return custom;
  return shareLinkShortLabel(profile.link);
}

String shareLinkShortLabel(String link) {
  try {
    final profile = const ShareLinkParser().parse(link.trim());
    final host = switch (profile) {
      TrustTunnelProfile(:final hostname, :final endpoint) =>
        (hostname != null && hostname.isNotEmpty) ? hostname : endpoint,
      HysteriaProfile(:final address, :final port) => '$address:$port',
      XrayProfile(:final address, :final port) => '$address:$port',
    };
    final name = profile.name.trim();
    if (name.isNotEmpty && name != host) return name;
    return host;
  } catch (_) {
    final trimmed = link.trim();
    if (trimmed.length <= 36) return trimmed;
    return '${trimmed.substring(0, 36)}…';
  }
}

String protocolKind(VpnProfile profile) => switch (profile) {
      TrustTunnelProfile() => 'tt',
      HysteriaProfile() => 'hy2',
      XrayProfile(:final protocol) => protocol.name,
    };

String? protocolKindForLink(String link) {
  try {
    return protocolKind(const ShareLinkParser().parse(link.trim()));
  } catch (_) {
    return null;
  }
}
