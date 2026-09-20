import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:goodwin_vpn_client/features/connection/presentation/bloc/connection_selection_cubit.dart';
import 'package:goodwin_vpn_client/features/home/presentation/home_network_copy.dart';
import 'package:goodwin_vpn_client/features/home/presentation/home_page.dart';
import 'package:goodwin_vpn_client/features/routing/data/stub_vpn_routing_engine.dart';
import 'package:goodwin_vpn_client/features/routing/domain/usecases/routing_use_cases.dart';
import 'package:goodwin_vpn_client/features/routing/presentation/bloc/routing_bloc.dart';
import 'package:goodwin_vpn_client/features/settings/presentation/bloc/app_settings_bloc.dart';
import 'package:goodwin_vpn_client/features/vpn/presentation/bloc/vpn_connection_bloc.dart';
import 'package:goodwin_vpn_client/l10n/app_localizations.dart';
import 'package:goodwin_vpn_client/l10n/app_localizations_en.dart';
import 'package:goodwin_vpn_client/session/connection_controller.dart';
import 'package:goodwin_vpn_client/session/session_store.dart';
import 'package:goodwin_vpn_client/session/subscription.dart';
import 'package:goodwin_vpn_client/session/tunnel_elevation.dart';
import 'package:goodwin_vpn_client/session/vpn_connection_state.dart';
import 'package:goodwin_vpn_client/ui/ui.dart';
import 'package:goodwin_vpn_client/vpn/vpn_slot.dart';

import 'support/fakes.dart';

void main() {
  Future<void> pumpCopy(
    WidgetTester tester, {
    required bool tunnelSupported,
  }) async {
    final copy = homeNetworkCopy(
      l10n: AppLocalizationsEn(),
      connected: false,
      busy: false,
      tunnelSupported: tunnelSupported,
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: buildGwTheme(Brightness.light),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Column(
            children: [
              Text(copy.title),
              Text(copy.subtitle),
              GwConnectButton(
                connected: false,
                busy: false,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  testWidgets('system tunnel Home copy + Connect, not Protected', (tester) async {
    await pumpCopy(tester, tunnelSupported: true);
    expect(find.text('Disconnected'), findsOneWidget);
    expect(find.byType(GwConnectButton), findsOneWidget);
    expect(
      find.text('Connect starts a system VPN on this device'),
      findsOneWidget,
    );
    expect(find.text('Protected'), findsNothing);
    expect(find.textContaining('end-to-end'), findsNothing);
  });

  testWidgets('no-TUN Home copy is Local SOCKS', (tester) async {
    await pumpCopy(tester, tunnelSupported: false);
    expect(find.text('Disconnected'), findsOneWidget);
    expect(find.byType(GwConnectButton), findsOneWidget);
    expect(find.textContaining('no system VPN'), findsOneWidget);
    expect(find.text('System VPN'), findsNothing);
  });

  testWidgets('quota and revoke strings Home actually shows', (tester) async {
    const info = SubscriptionUserinfo(
      download: 1048576,
      total: 1073741824,
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: buildGwTheme(Brightness.light),
        home: Scaffold(
          body: Column(
            children: [
              Text(info.displayLine),
              const Text(SubscriptionUserinfo.quotaScopeNote),
              const Text('Subscription link was revoked'),
            ],
          ),
        ),
      ),
    );
      expect(find.textContaining('Hy2'), findsOneWidget);
    expect(find.text('Subscription link was revoked'), findsOneWidget);
  });

  testWidgets('error HomePage shows Retry copy, not disconnect/ready', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'onboarding_completed': true,
      'vpn_explainer_seen': true,
    });
    final prefs = await SharedPreferences.getInstance();
    final tunnel = FakeSystemTunnel();
    final owned = FakeOwnedVpnEngine();
    final core = FakeSocksEngine(id: 'xray', engineVersion: '1.0');
    final cores = FakeSocksCoreResolver(core);
    final slot = VpnSlot(systemTunnel: tunnel, ownedEngine: owned);
    final store = MemorySessionStore();
    const link =
        'vless://11111111-2222-3333-4444-555555555555@example.com:443'
        '?encryption=none&type=tcp&security=tls#node';
    await store.addSavedProfile(link, name: 'Node');
    late VpnConnectionBloc vpnBloc;
    final controller = ConnectionController(
      slot: slot,
      tunnel: tunnel,
      owned: owned,
      cores: cores,
      store: store,
      parseShareLink: (_) => sampleXray(),
      onState: (s) {
        vpnBloc.emitState(s);
      },
    );
    vpnBloc = VpnConnectionBloc(controller: controller, tunnel: tunnel);

    final settings = AppSettingsBloc(prefs: prefs);
    final routingEngine = StubVpnRoutingEngine();
    final routingBloc = RoutingBloc(
      loadRouting: LoadRoutingSnapshotUseCase(routingEngine),
      setMode: SetRoutingModeUseCase(routingEngine),
      setPreset: SetRoutingPresetUseCase(routingEngine),
      addRule: AddRoutingRuleUseCase(routingEngine),
      removeRule: RemoveRoutingRuleUseCase(routingEngine),
      resetRouting: ResetRoutingUseCase(routingEngine),
    );
    final selection = ConnectionSelectionCubit();

    final profiles = await store.savedProfiles();
    vpnBloc.emitState(
      VpnConnectionState(
        phase: ConnectionPhase.error,
        message: 'boom',
        savedProfiles: profiles,
        activeShareLink: link,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        theme: buildGwTheme(Brightness.light),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: vpnBloc),
            BlocProvider.value(value: settings),
            BlocProvider.value(value: selection),
            BlocProvider.value(value: routingBloc),
          ],
          child: const HomePage(restoreOnStart: false),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Add a profile to connect'), findsNothing);
    expect(find.text('Could not connect'), findsOneWidget);
    expect(find.text('Tap to retry'), findsOneWidget);
    expect(find.text('Tap to connect'), findsNothing);
    expect(find.text('Tap to disconnect'), findsNothing);

    await tester.tap(find.byType(GwConnectButton));
    await tester.pump();
    for (var i = 0; i < 80; i++) {
      if (vpnBloc.state.phase == ConnectionPhase.connected) break;
      await tester.pump(const Duration(milliseconds: 25));
    }
    expect(tunnel.startCalls, greaterThan(0));
    expect(core.startCalls, greaterThan(0));
    expect(vpnBloc.state.phase, ConnectionPhase.connected);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('empty HomePage shows add-profile CTA', (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding_completed': true,
      'vpn_explainer_seen': true,
    });
    final prefs = await SharedPreferences.getInstance();
    final tunnel = FakeSystemTunnel();
    final owned = FakeOwnedVpnEngine();
    final core = FakeSocksEngine(id: 'xray', engineVersion: '1.0');
    final cores = FakeSocksCoreResolver(core);
    final slot = VpnSlot(systemTunnel: tunnel, ownedEngine: owned);
    final store = MemorySessionStore();
    late VpnConnectionBloc vpnBloc;
    final controller = ConnectionController(
      slot: slot,
      tunnel: tunnel,
      owned: owned,
      cores: cores,
      store: store,
      parseShareLink: (_) => sampleXray(),
      onState: (s) {
        vpnBloc.emitState(s);
      },
    );
    vpnBloc = VpnConnectionBloc(controller: controller, tunnel: tunnel);
    final settings = AppSettingsBloc(prefs: prefs);
    final routingEngine = StubVpnRoutingEngine();
    final routingBloc = RoutingBloc(
      loadRouting: LoadRoutingSnapshotUseCase(routingEngine),
      setMode: SetRoutingModeUseCase(routingEngine),
      setPreset: SetRoutingPresetUseCase(routingEngine),
      addRule: AddRoutingRuleUseCase(routingEngine),
      removeRule: RemoveRoutingRuleUseCase(routingEngine),
      resetRouting: ResetRoutingUseCase(routingEngine),
    );
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        theme: buildGwTheme(Brightness.light),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: vpnBloc),
            BlocProvider.value(value: settings),
            BlocProvider.value(value: ConnectionSelectionCubit()),
            BlocProvider.value(value: routingBloc),
          ],
          child: const HomePage(restoreOnStart: false),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Add a profile to connect'), findsOneWidget);
    expect(find.textContaining('vless://'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('on-demand disarm fail stays Connected with honest copy',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'onboarding_completed': true,
      'vpn_explainer_seen': true,
    });
    final prefs = await SharedPreferences.getInstance();
    final tunnel = FakeSystemTunnel();
    final owned = FakeOwnedVpnEngine();
    final core = FakeSocksEngine(id: 'xray', engineVersion: '1.0');
    final cores = FakeSocksCoreResolver(core);
    final slot = VpnSlot(systemTunnel: tunnel, ownedEngine: owned);
    final store = MemorySessionStore();
    const link =
        'vless://11111111-2222-3333-4444-555555555555@example.com:443'
        '?encryption=none&type=tcp&security=tls#node';
    await store.addSavedProfile(link, name: 'Node');
    late VpnConnectionBloc vpnBloc;
    final controller = ConnectionController(
      slot: slot,
      tunnel: tunnel,
      owned: owned,
      cores: cores,
      store: store,
      parseShareLink: (_) => sampleXray(),
      onState: (s) {
        vpnBloc.emitState(s);
      },
    );
    vpnBloc = VpnConnectionBloc(controller: controller, tunnel: tunnel);
    final settings = AppSettingsBloc(prefs: prefs);
    final routingEngine = StubVpnRoutingEngine();
    final routingBloc = RoutingBloc(
      loadRouting: LoadRoutingSnapshotUseCase(routingEngine),
      setMode: SetRoutingModeUseCase(routingEngine),
      setPreset: SetRoutingPresetUseCase(routingEngine),
      addRule: AddRoutingRuleUseCase(routingEngine),
      removeRule: RemoveRoutingRuleUseCase(routingEngine),
      resetRouting: ResetRoutingUseCase(routingEngine),
    );
    vpnBloc.emitState(
      VpnConnectionState(
        phase: ConnectionPhase.connected,
        message: OnDemandDisarmFailed.marker,
        savedProfiles: await store.savedProfiles(),
        activeShareLink: link,
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        theme: buildGwTheme(Brightness.light),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: vpnBloc),
            BlocProvider.value(value: settings),
            BlocProvider.value(value: ConnectionSelectionCubit()),
            BlocProvider.value(value: routingBloc),
          ],
          child: const HomePage(restoreOnStart: false),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('System VPN'), findsOneWidget);
    expect(
      find.text(
        'Could not turn off on-demand. Disconnect may not stick until you retry.',
      ),
      findsOneWidget,
    );
    expect(find.text('Could not connect'), findsNothing);
    expect(find.text('Tap to disconnect'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
