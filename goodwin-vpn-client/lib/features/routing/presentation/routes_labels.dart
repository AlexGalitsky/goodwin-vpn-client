import '../../../l10n/app_localizations.dart';
import '../domain/models/routing_models.dart';
import '../domain/vpn_backend_capability.dart';
import '../domain/vpn_ui_features.dart';

String routingModeHint(
  AppLocalizations l10n,
  RoutingMode mode,
  VpnUiFeatures features,
) =>
    switch (mode) {
      RoutingMode.global => features.richRouting
          ? l10n.modeHintGlobalRich
          : features.rulesRouting
              ? l10n.modeHintGlobalTrustTunnel
              : l10n.modeHintGlobalSimple,
      RoutingMode.rules => features.blockRouting
          ? l10n.modeHintRules
          : l10n.modeHintRulesTrustTunnel,
      RoutingMode.direct => l10n.modeHintDirect,
    };

String routingPresetTitle(
  AppLocalizations l10n,
  RoutingPresetId id, {
  required bool geoPacks,
  required VpnBackendKind backend,
}) =>
    switch (id) {
      RoutingPresetId.blockAds => geoPacks
          ? (backend == VpnBackendKind.trustTunnel
              ? l10n.presetBypassAdsPack
              : l10n.presetBlockAdsPack)
          : l10n.presetBlockAds,
      RoutingPresetId.bypassRegion => l10n.presetBypassLan,
      RoutingPresetId.protectBanking => l10n.presetProtectBanking,
    };

String routingPresetSubtitle(
  AppLocalizations l10n,
  RoutingPresetId id,
  VpnUiFeatures features, {
  required bool geoPacks,
  required VpnBackendKind backend,
}) =>
    switch (id) {
      RoutingPresetId.blockAds => geoPacks
          ? (backend == VpnBackendKind.trustTunnel
              ? l10n.presetBlockAdsPackTrustTunnel
              : l10n.presetBlockAdsPackXray)
          : l10n.presetBlockAdsSubtitle,
      RoutingPresetId.bypassRegion => features.excludeCidrUnavailableHint != null
          ? l10n.presetBypassLanAndroid13
          : l10n.presetBypassLanSubtitle,
      RoutingPresetId.protectBanking => l10n.presetProtectBankingSubtitle,
    };

bool routingPresetVisible(
  RoutingPresetId preset,
  VpnUiFeatures features, {
  required bool geoPacks,
  required VpnBackendKind backend,
}) =>
    switch (preset) {
      RoutingPresetId.blockAds =>
        features.blockRouting ||
            (backend == VpnBackendKind.trustTunnel && geoPacks),
      RoutingPresetId.bypassRegion =>
        features.excludeCidr || features.excludeCidrUnavailableHint != null,
      RoutingPresetId.protectBanking => features.perAppSplit,
    };

bool routingPresetEnabled(
  RoutingPresetId preset,
  VpnUiFeatures features, {
  required bool geoPacks,
  required VpnBackendKind backend,
}) =>
    switch (preset) {
      RoutingPresetId.blockAds =>
        features.blockRouting ||
            (backend == VpnBackendKind.trustTunnel && geoPacks),
      RoutingPresetId.bypassRegion => features.excludeCidr,
      RoutingPresetId.protectBanking => features.perAppSplit,
    };

bool looksLikeIpOrCidr(String matcher) {
  final t = matcher.trim();
  if (t.contains('/')) return true;
  final parts = t.split('.');
  if (parts.length == 4 && parts.every((p) => int.tryParse(p) != null)) {
    return true;
  }
  return t.contains(':');
}
