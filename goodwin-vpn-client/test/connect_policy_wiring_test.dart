import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:goodwin_vpn_client/core/config/dns_mode.dart';
import 'package:goodwin_vpn_client/core/di/app_connect_policy_resolver.dart';
import 'package:goodwin_vpn_client/features/routing/data/stub_vpn_routing_engine.dart';
import 'package:goodwin_vpn_client/features/routing/domain/models/routing_models.dart';
import 'package:goodwin_vpn_client/features/settings/presentation/bloc/app_settings_bloc.dart';
import 'package:goodwin_vpn_client/session/connection_controller.dart';
import 'package:goodwin_vpn_client/session/goodwin_geo.dart';
import 'package:goodwin_vpn_client/session/goodwin_geo_cache.dart';
import 'package:goodwin_vpn_client/session/saved_profile.dart';
import 'package:goodwin_vpn_client/session/session_store.dart';
import 'package:goodwin_vpn_client/session/subscription.dart';
import 'package:goodwin_vpn_client/session/vpn_connection_state.dart';
import 'package:goodwin_vpn_client/vpn/vpn_slot.dart';

import 'support/fakes.dart';

void main() {
  group('connect policy → Xray JSON', () {
    late FakeSystemTunnel tunnel;
    late FakeOwnedVpnEngine owned;
    late FakeSocksEngine core;
    late FakeSocksCoreResolver cores;
    late VpnSlot slot;
    late MemorySessionStore store;
    late StubVpnRoutingEngine routing;
    late AppSettingsBloc settings;
    late ConnectionController controller;
    late VpnConnectionState last;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      tunnel = FakeSystemTunnel();
      owned = FakeOwnedVpnEngine();
      core = FakeSocksEngine(id: 'xray', engineVersion: '1.0');
      cores = FakeSocksCoreResolver(core);
      slot = VpnSlot(systemTunnel: tunnel, ownedEngine: owned);
      store = MemorySessionStore();
      routing = StubVpnRoutingEngine();
      settings = AppSettingsBloc(prefs: prefs);
      last = const VpnConnectionState(phase: ConnectionPhase.idle);
      controller = ConnectionController(
        slot: slot,
        tunnel: tunnel,
        owned: owned,
        cores: cores,
        store: store,
        connectPolicy: AppConnectPolicyResolver(
          routingEngine: routing,
          settingsBloc: settings,
        ),
        killSwitchEnabled: () => settings.state.killSwitch,
        parseShareLink: (_) => sampleXray(),
        onState: (s) => last = s,
      );
    });

    tearDown(() async {
      await controller.disconnect();
      await settings.close();
    });

    test('Rules mode custom rule appears in configJson', () async {
      await routing.setMode(RoutingMode.rules);
      await routing.addRule(
        matcher: '.ads.example',
        action: RoutingAction.block,
      );
      await routing.addRule(
        matcher: '10.0.0.0/8',
        action: RoutingAction.direct,
      );
      await store.setExcludeRoutes(['203.0.113.10']);

      await controller.connect('xray');
      await pumpEventQueue();

      expect(last.phase, ConnectionPhase.connected);
      expect(cores.lastXrayOptions?.extraRules, isNotEmpty);
      expect(cores.lastXrayOptions?.resolvedDefaultOutbound, 'proxy');

      final root = jsonDecode(cores.lastConfigJson!) as Map<String, dynamic>;
      final rules = root['routing']['rules'] as List;
      expect(
        rules.any(
          (r) =>
              r['outboundTag'] == 'block' &&
              (r['domain'] as List).contains('domain:ads.example'),
        ),
        isTrue,
      );
      expect(tunnel.lastExcludeRoutes, contains('10.0.0.0/8'));
      expect(tunnel.lastExcludeRoutes, contains('203.0.113.10'));
    });

    test('Direct mode catch-all → direct', () async {
      await routing.setMode(RoutingMode.direct);
      await controller.connect('xray');
      await pumpEventQueue();

      expect(cores.lastXrayOptions?.resolvedDefaultOutbound, 'direct');
      final root = jsonDecode(cores.lastConfigJson!) as Map<String, dynamic>;
      final rules = root['routing']['rules'] as List;
      expect(rules.last['outboundTag'], 'direct');
    });

    test('Settings mux/fragment/dns applied for Xray', () async {
      settings.add(
        const AppSettingsVpnPreferencesUpdated(
          coreMux: true,
          coreFragment: true,
          dnsMode: DnsMode.custom,
          dnsCustom: '1.1.1.1, 8.8.8.8',
        ),
      );
      await pumpEventQueue();

      await controller.connect('xray');
      await pumpEventQueue();

      final opts = cores.lastXrayOptions!;
      expect(opts.mux, isTrue);
      expect(opts.fragment, isTrue);
      expect(opts.dnsServers, ['1.1.1.1', '8.8.8.8']);

      final root = jsonDecode(cores.lastConfigJson!) as Map<String, dynamic>;
      expect(root['dns']['servers'], ['1.1.1.1', '8.8.8.8']);
      final proxy = (root['outbounds'] as List).first as Map<String, dynamic>;
      expect(proxy['mux']['enabled'], isTrue);

      expect(tunnel.lastDnsServers, ['1.1.1.1', '8.8.8.8']);
    });

    test(
      'Protect banking + user apps merge into Android disallow list',
      () async {
        await routing.setPreset(
          id: RoutingPresetId.protectBanking,
          enabled: true,
        );
        await store.setDisallowedPackages(['com.example.custom']);

        await controller.connect('xray');
        await pumpEventQueue();

        expect(tunnel.lastDisallowedPackages, contains('com.example.custom'));
        expect(tunnel.lastDisallowedPackages, contains('ru.sberbankmobile'));
      },
    );

    test('Kill Switch preference is forwarded to TUN start', () async {
      settings.add(const AppSettingsVpnPreferencesUpdated(killSwitch: true));
      await pumpEventQueue();

      await controller.connect('xray');
      await pumpEventQueue();

      expect(tunnel.lastKillSwitch, isTrue);
    });

    test('custom SOCKS port/user/pass from settings reach Xray and TUN', () async {
      settings.add(
        const AppSettingsVpnPreferencesUpdated(
          socksPort: 19080,
          socksUsername: 'alice',
          socksPassword: 'secret',
        ),
      );
      await pumpEventQueue();

      await controller.connect('xray');
      await pumpEventQueue();

      expect(last.phase, ConnectionPhase.connected);
      expect(tunnel.lastSocksUsername, 'alice');
      expect(tunnel.lastSocksPassword, 'secret');
      final root = jsonDecode(cores.lastConfigJson!) as Map<String, dynamic>;
      final inbound = (root['inbounds'] as List).first as Map<String, dynamic>;
      expect(inbound['port'], 19080);
      expect(inbound['settings']['auth'], 'password');
      expect(inbound['settings']['accounts'][0]['user'], 'alice');
      expect(inbound['settings']['accounts'][0]['pass'], 'secret');
    });
  });

  group('mux / fragment vs typical VLESS', () {
    late FakeSystemTunnel tunnel;
    late FakeOwnedVpnEngine owned;
    late FakeSocksEngine core;
    late FakeSocksCoreResolver cores;
    late VpnSlot slot;
    late MemorySessionStore store;
    late StubVpnRoutingEngine routing;
    late AppSettingsBloc settings;
    late VpnConnectionState last;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      tunnel = FakeSystemTunnel();
      owned = FakeOwnedVpnEngine();
      core = FakeSocksEngine(id: 'xray', engineVersion: '1.0');
      cores = FakeSocksCoreResolver(core);
      slot = VpnSlot(systemTunnel: tunnel, ownedEngine: owned);
      store = MemorySessionStore();
      routing = StubVpnRoutingEngine();
      settings = AppSettingsBloc(prefs: prefs);
      settings.add(
        const AppSettingsVpnPreferencesUpdated(
          coreMux: true,
          coreFragment: true,
        ),
      );
      await pumpEventQueue();
      last = const VpnConnectionState(phase: ConnectionPhase.idle);
    });

    tearDown(() async {
      await settings.close();
    });

    ConnectionController controllerFor(XrayProfile profile) {
      return ConnectionController(
        slot: slot,
        tunnel: tunnel,
        owned: owned,
        cores: cores,
        store: store,
        connectPolicy: AppConnectPolicyResolver(
          routingEngine: routing,
          settingsBloc: settings,
        ),
        killSwitchEnabled: () => settings.state.killSwitch,
        parseShareLink: (_) => profile,
        onState: (s) => last = s,
      );
    }

    test('fleet gRPC REALITY: Fragment ON does not emit tlshello', () async {
      final controller = controllerFor(sampleGoodwinVless());
      await controller.connect('xray');
      await pumpEventQueue();

      expect(last.phase, ConnectionPhase.connected);
      final root = jsonDecode(cores.lastConfigJson!) as Map<String, dynamic>;
      final outbounds = root['outbounds'] as List;
      final proxy = outbounds.first as Map<String, dynamic>;
      expect(proxy['streamSettings']['security'], 'reality');
      expect(proxy['streamSettings'].containsKey('sockopt'), isFalse);
      expect(
        outbounds.any((o) => (o as Map)['tag'] == 'fragment'),
        isFalse,
      );
      expect(last.logs.any((l) => l.contains('fragment skipped')), isTrue);
      await controller.disconnect();
    });

    test('Vision REALITY: Mux ON does not emit mux — still Connected', () async {
      final controller = controllerFor(sampleVisionVless());
      await controller.connect('xray');
      await pumpEventQueue();

      expect(last.phase, ConnectionPhase.connected);
      final root = jsonDecode(cores.lastConfigJson!) as Map<String, dynamic>;
      final outbounds = root['outbounds'] as List;
      final proxy = outbounds.first as Map<String, dynamic>;
      expect(proxy.containsKey('mux'), isFalse);
      expect(proxy['streamSettings'].containsKey('sockopt'), isFalse);
      expect(
        outbounds.any((o) => (o as Map)['tag'] == 'fragment'),
        isFalse,
      );
      expect(last.logs.any((l) => l.contains('mux skipped')), isTrue);
      expect(last.logs.any((l) => l.contains('fragment skipped')), isTrue);
      await controller.disconnect();
    });
  });

  group('connect policy → TrustTunnel exclusions', () {
    late FakeSystemTunnel tunnel;
    late FakeOwnedVpnEngine owned;
    late FakeSocksEngine core;
    late FakeSocksCoreResolver cores;
    late VpnSlot slot;
    late MemorySessionStore store;
    late StubVpnRoutingEngine routing;
    late AppSettingsBloc settings;
    late ConnectionController controller;
    late VpnConnectionState last;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      tunnel = FakeSystemTunnel();
      owned = FakeOwnedVpnEngine();
      core = FakeSocksEngine(id: 'xray', engineVersion: '1.0');
      cores = FakeSocksCoreResolver(core);
      slot = VpnSlot(systemTunnel: tunnel, ownedEngine: owned);
      store = MemorySessionStore();
      routing = StubVpnRoutingEngine();
      settings = AppSettingsBloc(prefs: prefs);
      last = const VpnConnectionState(phase: ConnectionPhase.idle);
      controller = ConnectionController(
        slot: slot,
        tunnel: tunnel,
        owned: owned,
        cores: cores,
        store: store,
        connectPolicy: AppConnectPolicyResolver(
          routingEngine: routing,
          settingsBloc: settings,
        ),
        parseShareLink: (_) => sampleTrustTunnel(),
        onState: (s) => last = s,
      );
    });

    tearDown(() async {
      owned.emitDisconnected();
      await controller.disconnect();
      await settings.close();
    });

    test(
      'Rules direct domain reaches plugin excludes; block does not',
      () async {
        await routing.setMode(RoutingMode.rules);
        await routing.addRule(
          matcher: '.corp.local',
          action: RoutingAction.direct,
        );
        await routing.addRule(
          matcher: 'ads.example',
          action: RoutingAction.block,
        );
        await routing.addRule(
          matcher: '10.1.0.0/16',
          action: RoutingAction.direct,
        );
        await store.setExcludeRoutes(['always.exclude']);

        await controller.connect('tt');
        await pumpEventQueue();

        expect(last.phase, ConnectionPhase.connected);
        expect(owned.startCalls, 1);
        expect(owned.lastExcludeRoutes, contains('corp.local'));
        expect(owned.lastExcludeRoutes, contains('*.corp.local'));
        expect(owned.lastExcludeRoutes, contains('10.1.0.0/16'));
        expect(owned.lastExcludeRoutes, contains('always.exclude'));
        expect(owned.lastExcludeRoutes, isNot(contains('ads.example')));
        expect(
          last.logs.any((l) => l.contains('skipped') && l.contains('block')),
          isTrue,
        );
      },
    );

    test('Rules + ads pack excludes TrustTunnel ads', () async {
      const raw =
          '{"id":"ads","domains":[],"suffixes":[".doubleclick.net"],"cidrs":[]}';
      final body = utf8.encode(raw);
      final cache = MemoryGeoPackCache();
      await cache.write(
        serviceBase: 'https://panel.example',
        id: 'ads',
        sha256: sha256Hex(body),
        body: body,
      );
      const sub = VpnSubscription(
        id: 'sub-1',
        name: 'G',
        url: 'https://panel.example/sub',
        serviceBase: 'https://panel.example',
        protocolVersion: 1,
        features: ['geo-packs'],
      );
      await store.upsertSubscription(sub);
      await store.replaceSubscriptionNodes(
        subscriptionId: sub.id,
        nodes: [
          const SavedProfile(
            id: 'n1',
            name: 'tt',
            link: 'tt',
            subscriptionId: 'sub-1',
          ),
        ],
      );
      controller = ConnectionController(
        slot: slot,
        tunnel: tunnel,
        owned: owned,
        cores: cores,
        store: store,
        connectPolicy: AppConnectPolicyResolver(
          routingEngine: routing,
          settingsBloc: settings,
          store: store,
          geoCache: cache,
        ),
        parseShareLink: (_) => sampleTrustTunnel(),
        onState: (s) => last = s,
      );

      await routing.setMode(RoutingMode.rules);
      await routing.setPreset(id: RoutingPresetId.blockAds, enabled: true);
      await controller.connect('tt');
      await pumpEventQueue();

      expect(owned.lastExcludeRoutes, contains('doubleclick.net'));
      expect(owned.lastExcludeRoutes, contains('*.doubleclick.net'));
    });

    test('Direct mode does not dump traffic out of the tunnel', () async {
      await routing.setMode(RoutingMode.direct);
      await controller.connect('tt');
      await pumpEventQueue();

      expect(owned.lastExcludeRoutes, isEmpty);
      expect(
        last.logs.any(
          (l) => l.contains('tt direct') && l.contains('not applied'),
        ),
        isTrue,
      );
    });
  });
}
