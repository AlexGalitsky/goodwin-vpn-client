import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:goodwin_vpn_client/core/config/ui_mode.dart';
import 'package:goodwin_vpn_client/core/router/app_router.dart';
import 'package:goodwin_vpn_client/core/router/scaffold_with_nav_bar.dart';
import 'package:goodwin_vpn_client/features/connection/presentation/bloc/connection_selection_cubit.dart';
import 'package:goodwin_vpn_client/features/home/presentation/home_page.dart';
import 'package:goodwin_vpn_client/features/onboarding/onboarding_page.dart';
import 'package:goodwin_vpn_client/features/routing/data/stub_vpn_routing_engine.dart';
import 'package:goodwin_vpn_client/features/routing/domain/usecases/routing_use_cases.dart';
import 'package:goodwin_vpn_client/features/routing/presentation/bloc/routing_bloc.dart';
import 'package:goodwin_vpn_client/features/servers/presentation/qr_import_page.dart';
import 'package:goodwin_vpn_client/features/servers/presentation/servers_page.dart';
import 'package:goodwin_vpn_client/features/settings/presentation/bloc/app_settings_bloc.dart';
import 'package:goodwin_vpn_client/features/settings/presentation/licenses_page.dart';
import 'package:goodwin_vpn_client/features/settings/presentation/privacy_page.dart';
import 'package:goodwin_vpn_client/features/settings/presentation/settings_page.dart';
import 'package:goodwin_vpn_client/features/vpn/presentation/bloc/vpn_connection_bloc.dart';
import 'package:goodwin_vpn_client/l10n/app_localizations.dart';
import 'package:goodwin_vpn_client/l10n/app_localizations_en.dart';
import 'package:goodwin_vpn_client/session/connection_controller.dart';
import 'package:goodwin_vpn_client/session/session_store.dart';
import 'package:goodwin_vpn_client/session/vpn_connection_state.dart';
import 'package:goodwin_vpn_client/ui/ui.dart';
import 'package:goodwin_vpn_client/vpn/vpn_slot.dart';

import 'support/fakes.dart';

Future<void> pumpPage(
  WidgetTester tester, {
  required Widget child,
  Locale locale = const Locale('en'),
  Map<String, Object> prefs = const {},
}) async {
  SharedPreferences.setMockInitialValues({
    'onboarding_completed': true,
    ...prefs,
  });
  final shared = await SharedPreferences.getInstance();
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
  final settings = AppSettingsBloc(prefs: shared);
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
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: vpnBloc),
        BlocProvider.value(value: settings),
        BlocProvider.value(
          value: ConnectionSelectionCubit(probe: FakeLatencyProbe()),
        ),
        BlocProvider.value(value: routingBloc),
      ],
      child: MaterialApp(
        locale: locale,
        theme: buildGwTheme(Brightness.light),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('standard nav is 4 tabs, advanced is 5', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SizedBox.shrink(),
      ),
    );
    final l10n = AppLocalizationsEn();
    expect(ScaffoldWithNavBar.navItems(l10n, advanced: false), hasLength(4));
    expect(ScaffoldWithNavBar.navItems(l10n, advanced: true), hasLength(5));
    expect(
      ScaffoldWithNavBar.navItems(l10n, advanced: false).map((i) => i.label),
      ['Home', 'Profiles', 'Rules', 'Settings'],
    );
    expect(
      ScaffoldWithNavBar.navItems(l10n, advanced: true).map((i) => i.label),
      ['Home', 'Profiles', 'Rules', 'Logs', 'Settings'],
    );
  });

  testWidgets('Standard shell paints 4 tabs, Advanced paints Logs', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({'onboarding_completed': true});
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
    final refresh = ChangeNotifier();
    addTearDown(refresh.dispose);
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: vpnBloc),
          BlocProvider.value(value: settings),
          BlocProvider.value(value: ConnectionSelectionCubit()),
          BlocProvider.value(value: routingBloc),
        ],
        child: MaterialApp.router(
          locale: const Locale('en'),
          theme: buildGwTheme(Brightness.light),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: createAppRouter(refreshListenable: refresh),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(GwBottomNav), findsOneWidget);
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Profiles'), findsOneWidget);
    expect(find.text('Rules'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Logs'), findsNothing);

    settings.add(const AppSettingsUiModeUpdated(UiMode.advanced));
    await tester.pumpAndSettle();
    expect(find.text('Logs'), findsOneWidget);
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Settings'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('RU shell localizes Home nav and Profiles header', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpPage(tester, child: const ServersPage(), locale: const Locale('ru'));
    expect(find.text('Профили серверов'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());

    SharedPreferences.setMockInitialValues({'onboarding_completed': true});
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
    final refresh = ChangeNotifier();
    addTearDown(refresh.dispose);
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: vpnBloc),
          BlocProvider.value(value: settings),
          BlocProvider.value(value: ConnectionSelectionCubit()),
          BlocProvider.value(value: routingBloc),
        ],
        child: MaterialApp.router(
          locale: const Locale('ru'),
          theme: buildGwTheme(Brightness.light),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: createAppRouter(refreshListenable: refresh),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Главная'), findsWidgets);
    expect(find.text('Профили'), findsOneWidget);
    expect(find.text('Настройки'), findsOneWidget);
    expect(find.text('Home'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('wide shell uses side nav instead of bottom bar', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({'onboarding_completed': true});
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
    final refresh = ChangeNotifier();
    addTearDown(refresh.dispose);
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: vpnBloc),
          BlocProvider.value(value: settings),
          BlocProvider.value(value: ConnectionSelectionCubit()),
          BlocProvider.value(value: routingBloc),
        ],
        child: MaterialApp.router(
          locale: const Locale('en'),
          theme: buildGwTheme(Brightness.light),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: createAppRouter(refreshListenable: refresh),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(GwBottomNav), findsNothing);
    expect(find.byType(GwSideNav), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('iPad-width uses side nav, phone keeps bottom nav', (tester) async {
    tester.view.physicalSize = const Size(1032, 1376);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({'onboarding_completed': true});
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
    final refresh = ChangeNotifier();
    addTearDown(refresh.dispose);
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: vpnBloc),
          BlocProvider.value(value: settings),
          BlocProvider.value(value: ConnectionSelectionCubit()),
          BlocProvider.value(value: routingBloc),
        ],
        child: MaterialApp.router(
          locale: const Locale('en'),
          theme: buildGwTheme(Brightness.light),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: createAppRouter(refreshListenable: refresh),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(GwBottomNav), findsNothing);
    expect(find.byType(GwSideNav), findsOneWidget);

    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpAndSettle();
    expect(find.byType(GwBottomNav), findsOneWidget);
    expect(find.byType(GwSideNav), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('Settings opens Privacy page', (tester) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await pumpPage(tester, child: const SettingsPage());
    final aboutHub = find.text('Version, privacy, support');
    await tester.scrollUntilVisible(
      aboutHub,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(aboutHub);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Privacy'));
    await tester.pumpAndSettle();
    expect(find.byType(PrivacyPage), findsOneWidget);
    expect(find.text('What this app uses'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('Privacy page itself has policy CTA and no protocol schemes',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        theme: buildGwTheme(Brightness.light),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const PrivacyPage(),
      ),
    );
    expect(find.text('Privacy'), findsWidgets);
    expect(find.text('What this app uses'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Open privacy policy'),
      400,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text('Open privacy policy'), findsOneWidget);
    expect(find.textContaining('vless://'), findsNothing);
    expect(find.textContaining('hysteria2://'), findsNothing);
  });

  testWidgets('About has Support and opens Licenses', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await pumpPage(tester, child: const SettingsPage());
    await tester.tap(find.text('Version, privacy, support'));
    await tester.pumpAndSettle();
    expect(find.text('Support'), findsOneWidget);
    expect(find.text('Open-source licenses'), findsOneWidget);
    await tester.ensureVisible(find.text('Open-source licenses'));
    await tester.tap(find.text('Open-source licenses'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(LicensesPage), findsOneWidget);
    expect(find.text('Xray-core'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('import sheet hint has no protocol scheme', (tester) async {
    await pumpPage(tester, child: const ServersPage());
    await tester.tap(find.byTooltip('Import link or subscription'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(
      find.text(
        'Paste a share link or an https:// subscription URL. The app does not host a proxy.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('vless://'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('onboarding has three screens then completes', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final settings = AppSettingsBloc(prefs: prefs);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        theme: buildGwTheme(Brightness.light),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider.value(
          value: settings,
          child: const OnboardingPage(),
        ),
      ),
    );
    expect(find.text('Your server'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('System VPN'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Camera for QR'), findsOneWidget);
    expect(find.text('Skip'), findsNothing);
    await tester.tap(find.text('Get started'));
    await tester.pump();
    expect(settings.state.onboardingCompleted, isTrue);
    expect(settings.state.vpnExplainerSeen, isFalse);
    expect(settings.state.cameraExplainerSeen, isFalse);
  });

  testWidgets('onboarding skip still requires later VPN and camera explainers',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final settings = AppSettingsBloc(prefs: prefs);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        theme: buildGwTheme(Brightness.light),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider.value(
          value: settings,
          child: const OnboardingPage(),
        ),
      ),
    );
    await tester.tap(find.text('Skip'));
    await tester.pump();
    expect(settings.state.onboardingCompleted, isTrue);
    expect(settings.state.vpnExplainerSeen, isFalse);
    expect(settings.state.cameraExplainerSeen, isFalse);
  });

  testWidgets('cold start redirects to onboarding before Home', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final settings = AppSettingsBloc(prefs: prefs);
    final refresh = ChangeNotifier();
    addTearDown(refresh.dispose);
    await tester.pumpWidget(
      BlocProvider.value(
        value: settings,
        child: MaterialApp.router(
          locale: const Locale('en'),
          theme: buildGwTheme(Brightness.light),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: createAppRouter(refreshListenable: refresh),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingPage), findsOneWidget);
    expect(find.text('Your server'), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
  });

  testWidgets('Connect shows VPN explainer before the system tunnel sheet',
      (tester) async {
    SharedPreferences.setMockInitialValues({'onboarding_completed': true});
    final prefs = await SharedPreferences.getInstance();
    final tunnel = FakeSystemTunnel();
    final owned = FakeOwnedVpnEngine();
    final core = FakeSocksEngine(id: 'xray', engineVersion: '1.0');
    final cores = FakeSocksCoreResolver(core);
    final slot = VpnSlot(systemTunnel: tunnel, ownedEngine: owned);
    final store = MemorySessionStore();
    const link =
        'vless://11111111-2222-3333-4444-555555555555@203.0.113.1:443'
        '?encryption=none&type=tcp&security=tls#Node';
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
    vpnBloc.emitState(
      VpnConnectionState(
        phase: ConnectionPhase.idle,
        savedProfiles: await store.savedProfiles(),
        activeShareLink: link,
      ),
    );
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
    await tester.tap(find.byType(GwConnectButton));
    await tester.pumpAndSettle();
    expect(find.text('System VPN permission'), findsOneWidget);
    expect(tunnel.prepareCalls, 0);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(tunnel.prepareCalls, 0);
    expect(vpnBloc.state.phase, ConnectionPhase.idle);
    expect(settings.state.vpnExplainerSeen, isFalse);

    await tester.tap(find.byType(GwConnectButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(settings.state.vpnExplainerSeen, isTrue);
    expect(tunnel.prepareCalls, greaterThan(0));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('QR import shows camera explainer before the scanner',
      (tester) async {
    SharedPreferences.setMockInitialValues({'onboarding_completed': true});
    final prefs = await SharedPreferences.getInstance();
    final settings = AppSettingsBloc(prefs: prefs);
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        theme: buildGwTheme(Brightness.light),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider.value(
          value: settings,
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () => QrImportPage.open(context),
              child: const Text('Open QR'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open QR'));
    await tester.pumpAndSettle();
    expect(find.text('Camera permission'), findsOneWidget);
    expect(find.text('Scan QR'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(settings.state.cameraExplainerSeen, isFalse);
    expect(find.text('Camera permission'), findsNothing);
  });

  testWidgets('Profiles card shows protocol chip beside the name', (tester) async {
    SharedPreferences.setMockInitialValues({'onboarding_completed': true});
    final shared = await SharedPreferences.getInstance();
    final tunnel = FakeSystemTunnel();
    final owned = FakeOwnedVpnEngine();
    final core = FakeSocksEngine(id: 'xray', engineVersion: '1.0');
    final cores = FakeSocksCoreResolver(core);
    final slot = VpnSlot(systemTunnel: tunnel, ownedEngine: owned);
    final store = MemorySessionStore();
    const link =
        'vless://11111111-2222-3333-4444-555555555555@example.com:443'
        '?encryption=none&type=tcp&security=tls#Titan';
    await store.addSavedProfile(link, name: 'Titan');
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
    vpnBloc.emitState(
      VpnConnectionState(
        phase: ConnectionPhase.idle,
        savedProfiles: await store.savedProfiles(),
      ),
    );
    final settings = AppSettingsBloc(prefs: shared);
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
            BlocProvider.value(
              value: ConnectionSelectionCubit(probe: FakeLatencyProbe()),
            ),
            BlocProvider.value(value: routingBloc),
          ],
          child: const ServersPage(),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Titan'), findsWidgets);
    expect(find.byType(GwProtocolChip), findsOneWidget);
    expect(find.text('vless'), findsOneWidget);
    expect(find.textContaining('vless ·'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('Profiles tap while connected selects next node, does not drop TUN',
      (tester) async {
    SharedPreferences.setMockInitialValues({'onboarding_completed': true});
    final shared = await SharedPreferences.getInstance();
    final tunnel = FakeSystemTunnel();
    final owned = FakeOwnedVpnEngine();
    final core = FakeSocksEngine(id: 'xray', engineVersion: '1.0');
    final cores = FakeSocksCoreResolver(core);
    final slot = VpnSlot(systemTunnel: tunnel, ownedEngine: owned);
    final store = MemorySessionStore();
    const linkA =
        'vless://11111111-2222-3333-4444-555555555555@a.example.com:443'
        '?encryption=none&type=tcp&security=tls#NodeA';
    const linkB =
        'vless://11111111-2222-3333-4444-555555555555@b.example.com:443'
        '?encryption=none&type=tcp&security=tls#NodeB';
    await store.addSavedProfile(linkA, name: 'NodeA');
    await store.addSavedProfile(linkB, name: 'NodeB');
    final profiles = await store.savedProfiles();
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
    vpnBloc.emitState(
      VpnConnectionState(
        phase: ConnectionPhase.connected,
        savedProfiles: profiles,
        activeShareLink: linkA,
      ),
    );
    final selection = ConnectionSelectionCubit(probe: FakeLatencyProbe());
    final settings = AppSettingsBloc(prefs: shared);
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
            BlocProvider.value(value: selection),
            BlocProvider.value(value: routingBloc),
          ],
          child: const ServersPage(),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('NodeB'));
    await tester.pump();
    expect(vpnBloc.state.phase, ConnectionPhase.connected);
    expect(vpnBloc.state.activeShareLink, linkA);
    expect(tunnel.startCalls, 0);
    expect(tunnel.stopCalls, 0);
    expect(
      selection.state.selectedProfileId,
      profiles.firstWhere((p) => p.link == linkB).id,
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('Standard Settings hides Mux, Fragment, DoH, clipboard JSON',
      (tester) async {
    await pumpPage(tester, child: const SettingsPage());
    expect(find.text('Mux'), findsNothing);
    expect(find.text('Fragment'), findsNothing);
    expect(find.text('DoH'), findsNothing);
    expect(find.text('Copy JSON to clipboard'), findsNothing);
    expect(
      find.textContaining(RegExp(r'xray|hysteria|trusttunnel', caseSensitive: false)),
      findsNothing,
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
