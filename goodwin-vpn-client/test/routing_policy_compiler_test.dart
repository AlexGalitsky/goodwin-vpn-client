import 'package:flutter_test/flutter_test.dart';

import 'package:goodwin_vpn_client/features/routing/domain/geo_pack.dart';
import 'package:goodwin_vpn_client/features/routing/domain/models/routing_models.dart';
import 'package:goodwin_vpn_client/features/routing/domain/routing_matcher.dart';
import 'package:goodwin_vpn_client/features/routing/domain/routing_policy_compiler.dart';
import 'package:goodwin_vpn_client/features/routing/domain/routing_preset_lists.dart';

void main() {
  group('parseRoutingMatcher', () {
    test('IPv4 and CIDR → ip', () {
      expect(parseRoutingMatcher('10.0.0.1')?.kind, RoutingMatchKind.ip);
      expect(parseRoutingMatcher('10.0.0.0/8')?.value, '10.0.0.0/8');
    });

    test('IPv6 → ip', () {
      expect(parseRoutingMatcher('fe80::1')?.kind, RoutingMatchKind.ip);
      expect(parseRoutingMatcher('fc00::/7')?.kind, RoutingMatchKind.ip);
    });

    test('leading dot → domainSuffix', () {
      final parsed = parseRoutingMatcher('.Ads.Example');
      expect(parsed?.kind, RoutingMatchKind.domainSuffix);
      expect(parsed?.value, 'ads.example');
      expect(parsed?.xrayDomainEntry, 'domain:ads.example');
    });

    test('plain host → domain', () {
      final parsed = parseRoutingMatcher('Example.COM');
      expect(parsed?.kind, RoutingMatchKind.domain);
      expect(parsed?.xrayDomainEntry, 'domain:example.com');
    });

    test('rejects empty and junk', () {
      expect(parseRoutingMatcher(''), isNull);
      expect(parseRoutingMatcher('   '), isNull);
      expect(parseRoutingMatcher('not a host'), isNull);
      expect(parseRoutingMatcher('10.0.0.0/99'), isNull);
    });
  });

  group('outboundTagFor', () {
    test('maps actions', () {
      expect(outboundTagFor(RoutingAction.proxy), 'proxy');
      expect(outboundTagFor(RoutingAction.direct), 'direct');
      expect(outboundTagFor(RoutingAction.block), 'block');
    });
  });

  group('RoutingPresetLists', () {
    test('blockAds expands to block domain rules', () {
      final items = RoutingPresetLists.expand(RoutingPresetId.blockAds);
      expect(items, isNotEmpty);
      expect(items.every((e) => e.action == RoutingAction.block), isTrue);
      expect(items.every((e) => e.matcher.xrayDomainEntry != null), isTrue);
    });

    test('bypassRegion expands to direct CIDRs', () {
      final items = RoutingPresetLists.expand(RoutingPresetId.bypassRegion);
      expect(items, isNotEmpty);
      expect(items.every((e) => e.action == RoutingAction.direct), isTrue);
      expect(items.every((e) => e.matcher.kind == RoutingMatchKind.ip), isTrue);
    });

    test('protectBanking expands empty', () {
      expect(
        RoutingPresetLists.expand(RoutingPresetId.protectBanking),
        isEmpty,
      );
    });
  });

  group('RoutingPolicyCompiler', () {
    const compiler = RoutingPolicyCompiler();

    test('global → proxy, no extra rules', () {
      final policy = compiler.compile(const RoutingSnapshot());
      expect(policy.defaultOutbound, 'proxy');
      expect(policy.xrayRules, isEmpty);
      expect(policy.excludeRoutesExtra, isEmpty);
    });

    test('direct → default direct', () {
      final policy = compiler.compile(
        const RoutingSnapshot(mode: RoutingMode.direct),
      );
      expect(policy.defaultOutbound, 'direct');
      expect(policy.xrayRules, isEmpty);
    });

    test('rules: presets + custom → xray rules and excludes', () {
      final policy = compiler.compile(
        const RoutingSnapshot(
          mode: RoutingMode.rules,
          enabledPresets: {
            RoutingPresetId.blockAds,
            RoutingPresetId.bypassRegion,
            RoutingPresetId.protectBanking,
          },
          customRules: [
            RoutingRule(
              id: '1',
              matcher: '.corp.local',
              action: RoutingAction.direct,
            ),
            RoutingRule(
              id: '2',
              matcher: '203.0.113.10',
              action: RoutingAction.direct,
            ),
            RoutingRule(
              id: '3',
              matcher: 'not valid!!',
              action: RoutingAction.proxy,
            ),
          ],
        ),
      );

      expect(policy.defaultOutbound, 'proxy');
      expect(policy.xrayRules, isNotEmpty);
      expect(
        policy.xrayRules.any(
          (r) =>
              r['outboundTag'] == 'block' && (r['domain'] as List).isNotEmpty,
        ),
        isTrue,
      );
      expect(policy.excludeRoutesExtra, contains('10.0.0.0/8'));
      expect(policy.excludeRoutesExtra, contains('203.0.113.10'));
      expect(
        policy.capabilityNotes.any((n) => n.contains('protectBanking')),
        isTrue,
      );
      expect(
        policy.capabilityNotes.any((n) => n.contains('skipped invalid')),
        isTrue,
      );
      expect(
        policy.xrayRules.any(
          (r) =>
              r['outboundTag'] == 'direct' &&
              (r['domain'] as List?)?.contains('domain:corp.local') == true,
        ),
        isTrue,
      );
      expect(policy.excludeRoutesExtra, isNot(contains('corp.local')));
    });

    test(
      'TrustTunnel Rules: direct domains/CIDRs, skip block, no xray rules',
      () {
        final policy = compiler.compileTrustTunnel(
          const RoutingSnapshot(
            mode: RoutingMode.rules,
            enabledPresets: {
              RoutingPresetId.blockAds,
              RoutingPresetId.bypassRegion,
              RoutingPresetId.protectBanking,
            },
            customRules: [
              RoutingRule(
                id: '1',
                matcher: '.corp.local',
                action: RoutingAction.direct,
              ),
              RoutingRule(
                id: '2',
                matcher: '203.0.113.10',
                action: RoutingAction.direct,
              ),
              RoutingRule(
                id: '3',
                matcher: 'ads.example',
                action: RoutingAction.block,
              ),
            ],
          ),
        );

        expect(policy.defaultOutbound, 'proxy');
        expect(policy.xrayRules, isEmpty);
        expect(policy.excludeRoutesExtra, contains('corp.local'));
        expect(policy.excludeRoutesExtra, contains('*.corp.local'));
        expect(policy.excludeRoutesExtra, contains('203.0.113.10'));
        expect(policy.excludeRoutesExtra, contains('10.0.0.0/8'));
        expect(policy.excludeRoutesExtra, isNot(contains('doubleclick.net')));
        expect(policy.excludeRoutesExtra, isNot(contains('ads.example')));
        expect(
          policy.capabilityNotes.any((n) => n.contains('skipped')),
          isTrue,
        );
        expect(
          policy.capabilityNotes.any((n) => n.contains('protectBanking')),
          isTrue,
        );
      },
    );

    test('TrustTunnel Global and Direct do not emit extras', () {
      expect(
        compiler.compileTrustTunnel(const RoutingSnapshot()).excludeRoutesExtra,
        isEmpty,
      );
      final direct = compiler.compileTrustTunnel(
        const RoutingSnapshot(mode: RoutingMode.direct),
      );
      expect(direct.defaultOutbound, 'proxy');
      expect(direct.excludeRoutesExtra, isEmpty);
      expect(
        direct.capabilityNotes.any((n) => n.contains('not applied')),
        isTrue,
      );
    });

    test('Xray Rules with ads pack uses pack, not tiny list', () {
      const ads = GeoPack(
        id: 'ads',
        suffixes: ['.doubleclick.net', '.yandexadexchange.net'],
      );
      final policy = compiler.compile(
        const RoutingSnapshot(
          mode: RoutingMode.rules,
          enabledPresets: {RoutingPresetId.blockAds},
        ),
        ads: ads,
      );
      expect(
        policy.capabilityNotes.any((n) => n.contains('service ads pack')),
        isTrue,
      );
      expect(
        policy.xrayRules.any(
          (r) =>
              r['outboundTag'] == 'block' &&
              (r['domain'] as List).contains('domain:yandexadexchange.net'),
        ),
        isTrue,
      );
    });

    test(
      'TrustTunnel Rules with ads pack excludes, does not skip as block',
      () {
        const ads = GeoPack(id: 'ads', suffixes: ['.doubleclick.net']);
        final policy = compiler.compileTrustTunnel(
          const RoutingSnapshot(
            mode: RoutingMode.rules,
            enabledPresets: {RoutingPresetId.blockAds},
          ),
          ads: ads,
        );
        expect(policy.excludeRoutesExtra, contains('doubleclick.net'));
        expect(policy.excludeRoutesExtra, contains('*.doubleclick.net'));
        expect(
          policy.capabilityNotes.any((n) => n.contains('exclusions')),
          isTrue,
        );
        expect(
          policy.capabilityNotes.any((n) => n.contains('skipped')),
          isFalse,
        );
      },
    );
  });
}
