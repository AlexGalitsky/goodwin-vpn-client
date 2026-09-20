import 'geo_pack.dart';
import 'models/compiled_routing_policy.dart';
import 'models/routing_models.dart';
import 'routing_matcher.dart';
import 'routing_preset_lists.dart';

/// Pure: [RoutingSnapshot] → Xray rules + exclude extras (no I/O).
class RoutingPolicyCompiler {
  const RoutingPolicyCompiler();

  CompiledRoutingPolicy compile(RoutingSnapshot snapshot, {GeoPack? ads}) {
    return switch (snapshot.mode) {
      RoutingMode.global => CompiledRoutingPolicy(
        mode: RoutingMode.global,
        defaultOutbound: 'proxy',
        capabilityNotes: const [
          'global: all traffic → proxy (presets/rules ignored)',
        ],
      ),
      RoutingMode.direct => CompiledRoutingPolicy(
        mode: RoutingMode.direct,
        defaultOutbound: 'direct',
        capabilityNotes: const ['direct: all traffic → freedom; TUN stays up'],
      ),
      RoutingMode.rules => _compileRules(snapshot, ads: ads),
    };
  }

  /// TrustTunnel: [VpnMode.general] only. Direct domains/CIDRs → exclusions.
  /// Block is skipped. Catch-all Direct is not applied (no `selective` yet).
  CompiledRoutingPolicy compileTrustTunnel(
    RoutingSnapshot snapshot, {
    GeoPack? ads,
  }) {
    return switch (snapshot.mode) {
      RoutingMode.global => const CompiledRoutingPolicy(
        mode: RoutingMode.global,
        defaultOutbound: 'proxy',
        capabilityNotes: ['tt global: Always-exclude only'],
      ),
      RoutingMode.direct => const CompiledRoutingPolicy(
        mode: RoutingMode.direct,
        defaultOutbound: 'proxy',
        capabilityNotes: [
          'tt direct: not applied (no selective); traffic stays in tunnel except Always-exclude',
        ],
      ),
      RoutingMode.rules => _compileTrustTunnelRules(snapshot, ads: ads),
    };
  }

  CompiledRoutingPolicy _compileTrustTunnelRules(
    RoutingSnapshot snapshot, {
    GeoPack? ads,
  }) {
    final excludes = <String>{};
    final notes = <String>['tt rules: unmatched → tunnel; direct → exclusions'];
    var skippedBlock = 0;

    void consider({
      required ParsedRoutingMatcher parsed,
      required RoutingAction action,
    }) {
      switch (action) {
        case RoutingAction.proxy:
          return;
        case RoutingAction.block:
          skippedBlock++;
          return;
        case RoutingAction.direct:
          excludes.addAll(_ttDirectSpecs(parsed));
      }
    }

    for (final preset in RoutingPresetId.values) {
      if (!snapshot.isPresetEnabled(preset)) continue;
      if (preset == RoutingPresetId.protectBanking) {
        notes.add(
          'protectBanking: Android per-app bypass does not apply to TrustTunnel',
        );
        continue;
      }
      final note = RoutingPresetLists.capabilityNote(
        preset,
        ads: ads,
        trustTunnel: true,
      );
      if (note != null) notes.add(note);
      for (final item in RoutingPresetLists.expand(
        preset,
        ads: ads,
        trustTunnel: true,
      )) {
        consider(parsed: item.matcher, action: item.action);
      }
    }

    for (final rule in snapshot.customRules) {
      final parsed = parseRoutingMatcher(rule.matcher);
      if (parsed == null) {
        notes.add('skipped invalid matcher: ${rule.matcher}');
        continue;
      }
      consider(parsed: parsed, action: rule.action);
    }

    if (skippedBlock > 0) {
      notes.add(
        'tt: skipped $skippedBlock block matcher(s) (no plugin block outbound)',
      );
    }

    return CompiledRoutingPolicy(
      mode: RoutingMode.rules,
      defaultOutbound: 'proxy',
      excludeRoutesExtra: excludes.toList()..sort(),
      capabilityNotes: notes,
    );
  }

  CompiledRoutingPolicy _compileRules(
    RoutingSnapshot snapshot, {
    GeoPack? ads,
  }) {
    final xrayRules = <Map<String, dynamic>>[];
    final excludes = <String>{};
    final notes = <String>['rules: unmatched → proxy'];

    for (final preset in RoutingPresetId.values) {
      if (!snapshot.isPresetEnabled(preset)) continue;
      final note = RoutingPresetLists.capabilityNote(preset, ads: ads);
      if (note != null) notes.add(note);
      for (final item in RoutingPresetLists.expand(preset, ads: ads)) {
        _append(
          xrayRules: xrayRules,
          excludes: excludes,
          parsed: item.matcher,
          action: item.action,
        );
      }
    }

    for (final rule in snapshot.customRules) {
      final parsed = parseRoutingMatcher(rule.matcher);
      if (parsed == null) {
        notes.add('skipped invalid matcher: ${rule.matcher}');
        continue;
      }
      _append(
        xrayRules: xrayRules,
        excludes: excludes,
        parsed: parsed,
        action: rule.action,
      );
    }

    return CompiledRoutingPolicy(
      mode: RoutingMode.rules,
      defaultOutbound: 'proxy',
      xrayRules: xrayRules,
      excludeRoutesExtra: excludes.toList()..sort(),
      capabilityNotes: notes,
    );
  }

  /// Domain + `*.domain` for TT exclusions; IP/CIDR as-is for TUN excludes.
  List<String> _ttDirectSpecs(ParsedRoutingMatcher parsed) {
    switch (parsed.kind) {
      case RoutingMatchKind.ip:
        return [parsed.value];
      case RoutingMatchKind.domain:
      case RoutingMatchKind.domainSuffix:
        final host = parsed.value;
        if (host.startsWith('*.')) return [host];
        return [host, '*.$host'];
    }
  }

  void _append({
    required List<Map<String, dynamic>> xrayRules,
    required Set<String> excludes,
    required ParsedRoutingMatcher parsed,
    required RoutingAction action,
  }) {
    final tag = outboundTagFor(action);
    final domain = parsed.xrayDomainEntry;
    final ip = parsed.xrayIpEntry;
    final rule = <String, dynamic>{'type': 'field', 'outboundTag': tag};
    if (domain != null) {
      rule['domain'] = [domain];
    }
    if (ip != null) {
      rule['ip'] = [ip];
      if (action == RoutingAction.direct) {
        excludes.add(ip);
      }
    }
    xrayRules.add(rule);
  }
}
