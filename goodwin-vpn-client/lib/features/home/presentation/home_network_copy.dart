import '../../../l10n/app_localizations.dart';

/// Home status strings. System VPN vs local SOCKS must not share "Protected".
({String title, String subtitle}) homeNetworkCopy({
  required AppLocalizations l10n,
  required bool connected,
  required bool busy,
  required bool tunnelSupported,
  bool error = false,
}) {
  if (connected) {
    if (tunnelSupported) {
      return (
        title: l10n.homeConnectedTunnelTitle,
        subtitle: l10n.homeConnectedTunnelSubtitle,
      );
    }
    return (
      title: l10n.homeConnectedSocksTitle,
      subtitle: l10n.homeConnectedSocksSubtitle,
    );
  }
  if (error) {
    return (
      title: l10n.homeErrorTitle,
      subtitle: tunnelSupported ? l10n.homeErrorTunnel : l10n.homeErrorSocks,
    );
  }
  if (busy) {
    return (
      title: l10n.homeBusyTitle,
      subtitle: tunnelSupported ? l10n.homeBusyTunnel : l10n.homeBusySocks,
    );
  }
  return (
    title: l10n.homeReadyTitle,
    subtitle: tunnelSupported ? l10n.homeReadyTunnel : l10n.homeReadySocks,
  );
}
