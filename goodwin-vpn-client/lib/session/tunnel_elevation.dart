/// System TUN could not start because the process lacks OS privileges (Windows UAC).
class TunnelElevationRequired implements Exception {
  const TunnelElevationRequired();

  @override
  String toString() =>
      'Administrator privileges required for system VPN (Windows TUN)';
}

/// iOS on-demand / includeAllNetworks prefs did not save. The Packet Tunnel
/// is still up — Disconnect must not look like it stuck.
class OnDemandDisarmFailed implements Exception {
  const OnDemandDisarmFailed([this.detail]);

  final String? detail;

  static const marker = 'Could not turn off on-demand';

  static bool matches(String message) => message.contains(marker);

  @override
  String toString() {
    final extra = detail?.trim();
    if (extra == null || extra.isEmpty) return marker;
    return '$marker: $extra';
  }
}
