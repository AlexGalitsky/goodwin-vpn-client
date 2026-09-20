import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';

import '../../core/config/dns_mode.dart';
import '../../core/config/tun_dns.dart';
import '../../features/routing/domain/geo_pack.dart';
import '../../features/routing/domain/models/routing_models.dart';
import '../../features/routing/domain/repositories/vpn_routing_engine.dart';
import '../../features/routing/domain/routing_policy_compiler.dart';
import '../../features/settings/presentation/bloc/app_settings_bloc.dart';
import '../../features/split/domain/split_apps.dart';
import '../../session/connect_policy.dart';
import '../../session/goodwin_geo_cache.dart';
import '../../session/goodwin_service.dart';
import '../../session/saved_profile.dart';
import '../../session/session_store.dart';
import '../../session/socks_inbound.dart';
import '../../session/subscription.dart';

/// Wires [VpnRoutingEngine] + [AppSettingsBloc] into connect-time Xray options.
class AppConnectPolicyResolver implements ConnectPolicyResolver {
  AppConnectPolicyResolver({
    required VpnRoutingEngine routingEngine,
    required AppSettingsBloc settingsBloc,
    SessionStore? store,
    GeoPackCache? geoCache,
    this.compiler = const RoutingPolicyCompiler(),
  }) : _routingEngine = routingEngine,
       _settingsBloc = settingsBloc,
       _store = store,
       _geoCache = geoCache;

  final VpnRoutingEngine _routingEngine;
  final AppSettingsBloc _settingsBloc;
  final SessionStore? _store;
  final GeoPackCache? _geoCache;
  final RoutingPolicyCompiler compiler;

  @override
  Future<ResolvedConnectPolicy> resolve(
    VpnProfile profile, {
    String? shareLink,
    bool reuseSocksSession = false,
  }) async {
    final snapshot = await _routingEngine.load();
    final settings = _settingsBloc.state;
    final tunDns = tunDnsServersFromSettings(
      mode: settings.dnsMode,
      custom: settings.dnsCustom,
    );
    final ads = await _adsPack(shareLink);
    final socks = await _socks(settings, reuseSession: reuseSocksSession);

    if (profile is TrustTunnelProfile) {
      final compiled = compiler.compileTrustTunnel(snapshot, ads: ads);
      final notes = [...compiled.capabilityNotes];
      if (settings.coreMux || settings.coreFragment) {
        notes.add('mux/fragment are Xray-only — ignored for this profile');
      }
      return ResolvedConnectPolicy(
        extraExcludeRoutes: compiled.excludeRoutesExtra,
        tunDnsServers: tunDns,
        logNotes: notes,
        socks: socks,
      );
    }

    final compiled = compiler.compile(
      snapshot,
      ads: profile is XrayProfile ? ads : null,
    );
    final notes = [...compiled.capabilityNotes];

    if (profile is! XrayProfile) {
      if (snapshot.mode == RoutingMode.rules ||
          snapshot.mode == RoutingMode.direct) {
        notes.add(
          'routing mode ${snapshot.mode.name}: domain/block rules need Xray; '
          'IP excludes still merged for TUN',
        );
      }
      if (settings.coreMux || settings.coreFragment) {
        notes.add('mux/fragment are Xray-only — ignored for this profile');
      }
      return ResolvedConnectPolicy(
        extraExcludeRoutes: compiled.excludeRoutesExtra,
        extraDisallowedPackages: _disallowedPackages(snapshot),
        tunDnsServers: tunDns,
        logNotes: notes,
        socks: socks,
      );
    }

    final xrayOptions = XrayBuildOptions(
      defaultOutbound: compiled.defaultOutbound,
      extraRules: compiled.xrayRules,
      dnsServers: _xrayDnsServers(settings),
      mux: settings.coreMux,
      fragment: settings.coreFragment,
    );
    if (settings.coreMux && !xrayOptions.muxEnabledFor(profile)) {
      notes.add('mux skipped — incompatible with xtls-rprx-vision');
    }
    if (settings.coreFragment && !xrayOptions.fragmentEnabledFor(profile)) {
      notes.add('fragment skipped — not used with REALITY');
    }
    return ResolvedConnectPolicy(
      xrayOptions: xrayOptions,
      extraExcludeRoutes: compiled.excludeRoutesExtra,
      extraDisallowedPackages: _disallowedPackages(snapshot),
      tunDnsServers: tunDns,
      logNotes: notes,
      socks: socks,
    );
  }

  Future<SocksInbound> _socks(
    AppSettingsState settings, {
    required bool reuseSession,
  }) async {
    final socks = SocksInbound.resolve(
      port: settings.socksPort,
      username: settings.socksUsername,
      password: settings.socksPassword,
      sessionUsername: settings.socksSessionUsername,
      sessionPassword: settings.socksSessionPassword,
      reuseSession: reuseSession,
    );
    if (socks.username != settings.socksSessionUsername ||
        socks.password != settings.socksSessionPassword) {
      await _settingsBloc.rememberSocksSession(socks.username, socks.password);
    }
    return socks;
  }

  List<String> _disallowedPackages(RoutingSnapshot snapshot) {
    if (!snapshot.isPresetEnabled(RoutingPresetId.protectBanking)) {
      return const [];
    }
    return mergeDisallowedPackages(
      userSelected: const [],
      protectBanking: true,
    );
  }

  List<String>? _xrayDnsServers(AppSettingsState settings) {
    switch (settings.dnsMode) {
      case DnsMode.system:
        return null;
      case DnsMode.custom:
        final parts = _splitServers(settings.dnsCustom);
        return parts.isEmpty ? null : parts;
      case DnsMode.doh:
        final parts = _splitServers(settings.dnsCustom);
        if (parts.isEmpty) {
          return const ['https://1.1.1.1/dns-query'];
        }
        return [
          for (final part in parts)
            part.startsWith('https://') ? part : 'https://$part/dns-query',
        ];
    }
  }

  List<String> _splitServers(String? raw) {
    if (raw == null || raw.trim().isEmpty) return const [];
    return raw
        .split(RegExp(r'[\s,;]+'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<GeoPack?> _adsPack(String? shareLink) async {
    final cache = _geoCache;
    final store = _store;
    if (cache == null || store == null) return null;
    final link = shareLink ?? await store.lastShareLink();
    if (link == null || link.isEmpty) return null;
    final profiles = await store.savedProfiles();
    SavedProfile? saved;
    for (final profile in profiles) {
      if (profile.link == link) {
        saved = profile;
        break;
      }
    }
    final subId = saved?.subscriptionId;
    if (subId == null) return null;
    VpnSubscription? sub;
    for (final item in await store.subscriptions()) {
      if (item.id == subId) {
        sub = item;
        break;
      }
    }
    if (sub == null || !sub.features.contains(kGoodwinFeatureGeoPacks)) {
      return null;
    }
    final base = sub.serviceBase;
    if (base == null || base.isEmpty) return null;
    return cache.readAds(base);
  }
}
