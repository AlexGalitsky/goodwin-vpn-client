import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/config/ui_mode.dart';
import '../core/router/scaffold_with_nav_bar.dart';
import '../features/connection/presentation/bloc/connection_selection_cubit.dart';
import '../features/routing/data/stub_vpn_routing_engine.dart';
import '../features/routing/domain/usecases/routing_use_cases.dart';
import '../features/routing/presentation/bloc/routing_bloc.dart';
import '../features/settings/presentation/bloc/app_settings_bloc.dart';
import '../features/vpn/presentation/bloc/vpn_connection_bloc.dart';
import '../l10n/l10n_extension.dart';
import '../session/connection_controller.dart';
import '../session/session_store.dart';
import '../session/vpn_connection_state.dart';
import '../ui/ui.dart';
import '../vpn/vpn_slot.dart';
import 'store_demo_catalog.dart';
import 'store_demo_fakes.dart';

/// Provides real app blocs + theme with a seeded, store-safe VPN catalog.
///
/// Avoids nested [MaterialApp] so screenshot export can swap pages without a
/// stale [Navigator] route (flutter_store_screenshots reuses one capture slot).
class StoreDemoHost extends StatefulWidget {
  const StoreDemoHost({
    super.key,
    required this.child,
    this.locale = const Locale('en'),
    this.brightness = Brightness.dark,
    this.navIndex = 0,
    this.connected = true,
  });

  final Widget child;
  final Locale locale;
  final Brightness brightness;

  /// Highlighted tab in the chrome (0 Home, 1 Profiles, 2 Rules, 3 Settings).
  final int navIndex;

  final bool connected;

  @override
  State<StoreDemoHost> createState() => _StoreDemoHostState();
}

class _StoreDemoHostState extends State<StoreDemoHost> {
  late Future<_StoreDemoDeps> _ready;

  @override
  void initState() {
    super.initState();
    _ready = _StoreDemoDeps.create(connected: widget.connected);
  }

  @override
  void didUpdateWidget(covariant StoreDemoHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.connected != widget.connected) {
      _ready = _StoreDemoDeps.create(connected: widget.connected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_StoreDemoDeps>(
      future: _ready,
      builder: (context, snap) {
        final deps = snap.data;
        if (deps == null) {
          return const ColoredBox(
            color: Color(0xFF0B101A),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: deps.vpn),
            BlocProvider.value(value: deps.settings),
            BlocProvider.value(value: deps.selection),
            BlocProvider.value(value: deps.routing),
          ],
          child: Localizations(
            locale: widget.locale,
            delegates: AppLocalizations.localizationsDelegates,
            child: Theme(
              data: buildGwTheme(widget.brightness),
              // Keyed Navigator: Overlay for tooltips + remount when the shot
              // changes (export reuses one capture slot).
              child: Navigator(
                key: ValueKey(
                  'demo_${widget.navIndex}_${widget.connected}_'
                  '${widget.child.runtimeType}',
                ),
                onGenerateRoute: (_) => PageRouteBuilder<void>(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return Material(
                      type: MaterialType.transparency,
                      child: StoreDemoShell(
                        navIndex: widget.navIndex,
                        body: widget.child,
                      ),
                    );
                  },
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Product chrome (GwCanvas + bottom / side nav) without go_router.
class StoreDemoShell extends StatelessWidget {
  const StoreDemoShell({
    super.key,
    required this.navIndex,
    required this.body,
  });

  final int navIndex;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final advanced =
        context.watch<AppSettingsBloc>().state.uiMode == UiMode.advanced;
    final items = ScaffoldWithNavBar.navItems(
      context.l10n,
      advanced: advanced,
    );
    // Standard shell indices: Home, Profiles, Rules, Settings.
    final index = navIndex.clamp(0, items.length - 1);
    final window = GwBreakpoints.of(context);
    final side = GwBreakpoints.useSideNav(window);

    final content = side
        ? Row(
            children: [
              GwSideNav(
                items: items,
                currentIndex: index,
                onTap: (_) {},
                extended: GwBreakpoints.sideNavExtended(window),
              ),
              Expanded(child: body),
            ],
          )
        : body;

    return GwCanvas(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: content,
        bottomNavigationBar: side
            ? null
            : GwBottomNav(
                items: items,
                currentIndex: index,
                onTap: (_) {},
              ),
      ),
    );
  }
}

class _StoreDemoDeps {
  _StoreDemoDeps({
    required this.vpn,
    required this.settings,
    required this.selection,
    required this.routing,
  });

  final VpnConnectionBloc vpn;
  final AppSettingsBloc settings;
  final ConnectionSelectionCubit selection;
  final RoutingBloc routing;

  static Future<_StoreDemoDeps> create({required bool connected}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    await prefs.setBool('vpn_explainer_seen', true);
    await prefs.setBool('camera_explainer_seen', true);
    final tunnel = StoreDemoSystemTunnel();
    final owned = StoreDemoOwnedEngine();
    final core = StoreDemoSocksEngine();
    final cores = StoreDemoSocksCoreResolver(core);
    late VpnConnectionBloc vpnBloc;
    final controller = ConnectionController(
      slot: VpnSlot(systemTunnel: tunnel, ownedEngine: owned),
      tunnel: tunnel,
      owned: owned,
      cores: cores,
      store: MemorySessionStore(),
      parseShareLink: storeDemoParseProfile,
      onState: (s) => vpnBloc.emitState(s),
    );
    vpnBloc = VpnConnectionBloc(controller: controller, tunnel: tunnel);

    final profiles = StoreDemoCatalog.profiles();
    final subs = StoreDemoCatalog.subscriptions();
    final link = StoreDemoCatalog.frankfurtLink;
    vpnBloc.emitState(
      VpnConnectionState(
        phase: connected ? ConnectionPhase.connected : ConnectionPhase.idle,
        message: connected ? 'Connected' : '',
        savedProfiles: profiles,
        subscriptions: subs,
        activeShareLink: connected ? link : null,
        connectedAt: connected
            ? DateTime.now().toUtc().subtract(const Duration(minutes: 42))
            : null,
        smartConnect: true,
      ),
    );

    final selection = ConnectionSelectionCubit(
      probe: const StoreDemoLatencyProbe(),
    )..selectProfile(profiles.first.id);
    await selection.pingProfiles(profiles);

    final settings = AppSettingsBloc(prefs: prefs)
      ..add(const AppSettingsLoadRequested());
    final routingEngine = StubVpnRoutingEngine();
    final routing = RoutingBloc(
      loadRouting: LoadRoutingSnapshotUseCase(routingEngine),
      setMode: SetRoutingModeUseCase(routingEngine),
      setPreset: SetRoutingPresetUseCase(routingEngine),
      addRule: AddRoutingRuleUseCase(routingEngine),
      removeRule: RemoveRoutingRuleUseCase(routingEngine),
      resetRouting: ResetRoutingUseCase(routingEngine),
    )..add(const RoutingLoadRequested());

    // Let AppSettingsBloc / RoutingBloc process their first events.
    await Future<void>.delayed(Duration.zero);
    return _StoreDemoDeps(
      vpn: vpnBloc,
      settings: settings,
      selection: selection,
      routing: routing,
    );
  }
}
