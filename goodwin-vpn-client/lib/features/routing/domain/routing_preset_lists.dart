import 'geo_pack.dart';
import 'models/routing_models.dart';
import 'routing_matcher.dart';

/// Tiny built-in lists for presets (not geosite). Badge: limited.
abstract final class RoutingPresetLists {
  /// Common ad / tracker hosts → [RoutingAction.block].
  static const blockAdsDomains = <String>[
    'doubleclick.net',
    'googleadservices.com',
    'googlesyndication.com',
    'pagead2.googlesyndication.com',
    'adservice.google.com',
    'ads.youtube.com',
    'scorecardresearch.com',
    'advertising.com',
    'adnxs.com',
    'taboola.com',
  ];

  /// Private / link-local ranges → [RoutingAction.direct] (+ OS excludes).
  /// Prefs id remains [RoutingPresetId.bypassRegion] (storage stability).
  static const bypassLanCidrs = <String>[
    '10.0.0.0/8',
    '172.16.0.0/12',
    '192.168.0.0/16',
    '127.0.0.0/8',
    '169.254.0.0/16',
    'fc00::/7',
    'fe80::/10',
  ];

  static List<({ParsedRoutingMatcher matcher, RoutingAction action})> expand(
    RoutingPresetId id, {
    GeoPack? ads,
    bool trustTunnel = false,
  }) {
    return switch (id) {
      RoutingPresetId.blockAds => _expandBlockAds(
        ads: ads,
        trustTunnel: trustTunnel,
      ),
      RoutingPresetId.bypassRegion => [
        for (final cidr in bypassLanCidrs)
          (
            matcher: ParsedRoutingMatcher(
              kind: RoutingMatchKind.ip,
              value: cidr,
            ),
            action: RoutingAction.direct,
          ),
      ],
      RoutingPresetId.protectBanking => const [],
    };
  }

  static List<({ParsedRoutingMatcher matcher, RoutingAction action})>
  _expandBlockAds({required GeoPack? ads, required bool trustTunnel}) {
    if (ads != null && ads.id == 'ads' && ads.matcherCount > 0) {
      final action = trustTunnel ? RoutingAction.direct : RoutingAction.block;
      return ads.expand(action);
    }
    if (trustTunnel) {
      // Tiny list is Xray `block`; TT has no plugin block.
      return const [];
    }
    return [
      for (final host in blockAdsDomains)
        (
          matcher: ParsedRoutingMatcher(
            kind: RoutingMatchKind.domainSuffix,
            value: host,
          ),
          action: RoutingAction.block,
        ),
    ];
  }

  static String? capabilityNote(
    RoutingPresetId id, {
    GeoPack? ads,
    bool trustTunnel = false,
  }) => switch (id) {
    RoutingPresetId.blockAds =>
      ads != null && ads.matcherCount > 0
          ? (trustTunnel
                ? 'blockAds: service ads pack → exclusions (${ads.matcherCount})'
                : 'blockAds: service ads pack → block (${ads.matcherCount})')
          : (trustTunnel
                ? null
                : 'blockAds: limited built-in domain list (not geosite)'),
    RoutingPresetId.bypassRegion =>
      'bypassRegion (LAN): private/link-local CIDRs only — not geoip/region',
    RoutingPresetId.protectBanking =>
      'protectBanking: Android per-app bypass (disallowed packages)',
  };
}
