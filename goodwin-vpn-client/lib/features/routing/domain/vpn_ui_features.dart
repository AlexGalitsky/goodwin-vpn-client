import 'vpn_backend_capability.dart';
import '../../../platform_android_sdk.dart';
import 'models/routing_models.dart';

/// Android 13 (API 33) is the floor for [VpnService.excludeRoute].
const kAndroidExcludeCidrSdk = 33;

/// What the current OS + core can actually do. UI must hide the rest.
class VpnUiFeatures {
  const VpnUiFeatures({
    required this.perAppSplit,
    required this.killSwitch,
    required this.excludeCidr,
    required this.geosite,
    required this.xrayCoreTuning,
    required this.rulesRouting,
    required this.directRouting,
    required this.blockRouting,
    required this.qrCamera,
    this.excludeCidrUnavailableHint,
  });

  /// Android SOCKS TUN: [VpnService.addDisallowedApplication]. Not TrustTunnel.
  final bool perAppSplit;

  /// Phone system VPN: SOCKS Always-on / NE on-demand, or TrustTunnel
  /// session-scoped plugin KS (disarmed before SOCKS handoff).
  final bool killSwitch;

  /// CIDR/IP excludes on a real system tunnel (Android 13+, Windows, Apple NE).
  final bool excludeCidr;

  /// Shown when Bypass LAN exists in UI but CIDR exclude is a no-op (Android < 13).
  final String? excludeCidrUnavailableHint;

  /// geosite.dat / geoip.dat pipeline. Always false until assets ship.
  final bool geosite;

  /// Mux / fragment JSON — Xray only.
  final bool xrayCoreTuning;

  /// Global + Rules in the mode control (Xray and TrustTunnel).
  final bool rulesRouting;

  /// Xray Direct catch-all (`freedom`). Not TrustTunnel (`selective` unverified).
  final bool directRouting;

  /// Block outbound, Block-ads preset, and the block action chip. Xray only.
  final bool blockRouting;

  /// Full Xray routing: Rules + Direct + block.
  bool get richRouting => rulesRouting && directRouting && blockRouting;

  /// Live camera QR import. Android / iOS only — hide on desktop.
  final bool qrCamera;

  static const none = VpnUiFeatures(
    perAppSplit: false,
    killSwitch: false,
    excludeCidr: false,
    geosite: false,
    xrayCoreTuning: false,
    rulesRouting: false,
    directRouting: false,
    blockRouting: false,
    qrCamera: false,
  );

  /// Mode to show in the segmented control (hidden modes map to Global).
  /// Does not rewrite stored prefs.
  RoutingMode displayMode(RoutingMode stored) {
    if (stored == RoutingMode.direct && !directRouting) {
      return RoutingMode.global;
    }
    if (stored == RoutingMode.rules && !rulesRouting) {
      return RoutingMode.global;
    }
    return stored;
  }

  bool allowsMode(RoutingMode mode) => switch (mode) {
    RoutingMode.global => true,
    RoutingMode.rules => rulesRouting,
    RoutingMode.direct => directRouting,
  };

  List<RoutingAction> get allowedActions => [
    RoutingAction.proxy,
    RoutingAction.direct,
    if (blockRouting) RoutingAction.block,
  ];

  factory VpnUiFeatures.resolve({
    required bool isAndroid,
    required bool tunnelSupported,
    VpnBackendKind backend = VpnBackendKind.unknown,
    bool isIos = false,
    int? androidSdkInt,
  }) {
    final socksTun = tunnelSupported && backend != VpnBackendKind.trustTunnel;
    final xrayLike =
        backend == VpnBackendKind.xray || backend == VpnBackendKind.unknown;
    final tt = backend == VpnBackendKind.trustTunnel;
    final sdk = androidSdkInt ?? cachedAndroidSdkInt;
    final androidCidrOk =
        !isAndroid || (sdk != null && sdk >= kAndroidExcludeCidrSdk);
    final showAndroidCidrHint = isAndroid && tunnelSupported && !androidCidrOk;
    return VpnUiFeatures(
      perAppSplit: isAndroid && socksTun,
      killSwitch: (isAndroid || isIos) && tunnelSupported,
      excludeCidr: tunnelSupported && androidCidrOk,
      excludeCidrUnavailableHint: showAndroidCidrHint
          ? 'Bypass LAN needs Android 13+. CIDR excludes do nothing on this version.'
          : null,
      geosite: false,
      xrayCoreTuning: xrayLike,
      rulesRouting: xrayLike || tt,
      directRouting: xrayLike,
      blockRouting: xrayLike,
      qrCamera: isAndroid || isIos,
    );
  }
}
