import 'dart:async';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/connection/presentation/bloc/connection_selection_cubit.dart';
import '../../features/routing/data/prefs_vpn_routing_engine.dart';
import '../../features/routing/domain/usecases/routing_use_cases.dart';
import '../../features/routing/presentation/bloc/routing_bloc.dart';
import '../../features/settings/presentation/bloc/app_settings_bloc.dart';
import '../../features/vpn/presentation/bloc/vpn_connection_bloc.dart';
import '../../platform_android_sdk.dart';
import '../../platform_system_tunnel.dart';
import '../../session/connectivity_monitor.dart';
import '../../session/connection_controller.dart';
import '../../session/goodwin_geo_cache.dart';
import '../../session/goodwin_geo_client.dart';
import '../../session/goodwin_geo_prefetch.dart';
import '../../session/prefs_session_store.dart';
import '../../session/session_key_store.dart';
import '../../session/process_restarter.dart';
import '../../session/socks_core_resolver.dart';
import '../../trusttunnel_vpn.dart';
import '../../vpn/system_tunnel.dart';
import '../../vpn/vpn_slot.dart';
import 'app_connect_policy_resolver.dart';

/// Composition root (VirtueForge-style discipline, no GetIt).
final class AppDependencies {
  AppDependencies._({
    required this.prefs,
    required this.vpnConnectionBloc,
    required this.settingsBloc,
    required this.connectionSelectionCubit,
    required this.routingBloc,
    required this.tunnel,
    required List<StreamSubscription<dynamic>> subscriptions,
  }) : _subscriptions = subscriptions;

  final SharedPreferences prefs;
  final VpnConnectionBloc vpnConnectionBloc;
  final AppSettingsBloc settingsBloc;
  final ConnectionSelectionCubit connectionSelectionCubit;
  final RoutingBloc routingBloc;
  final SystemTunnel tunnel;
  final List<StreamSubscription<dynamic>> _subscriptions;

  static Future<AppDependencies> create() async {
    final prefs = await SharedPreferences.getInstance();
    await loadAndroidSdkInt();
    final tunnel = createSystemTunnel();
    final owned = TrustTunnelVpn();
    final connectivity = tunnel.isSupported ? ConnectivityPlusMonitor() : null;
    final settingsBloc = AppSettingsBloc(prefs: prefs)
      ..add(const AppSettingsLoadRequested());
    final routingEngine = PrefsVpnRoutingEngine(prefs);
    final store = PrefsSessionStore(keyStore: FlutterSessionKeyStore());
    final geoCache = PrefsGeoPackCache(prefs);
    late final VpnConnectionBloc vpnBloc;
    final controller = ConnectionController(
      slot: VpnSlot(systemTunnel: tunnel, ownedEngine: owned),
      tunnel: tunnel,
      owned: owned,
      cores: NativeSocksCoreResolver(),
      store: store,
      restarter: _platformRestarter(tunnel),
      connectivity: connectivity,
      connectPolicy: AppConnectPolicyResolver(
        routingEngine: routingEngine,
        settingsBloc: settingsBloc,
        store: store,
        geoCache: geoCache,
      ),
      geoPrefetch: GoodwinGeoPrefetcher(
        client: HttpGoodwinGeoClient(),
        cache: geoCache,
      ),
      killSwitchEnabled: () => settingsBloc.state.killSwitch,
      onState: (next) => vpnBloc.emitState(next),
    );
    vpnBloc = VpnConnectionBloc(controller: controller, tunnel: tunnel);

    final subscriptions = <StreamSubscription<dynamic>>[
      tunnel.events.listen(controller.handleTunnelEvent),
      owned.unexpectedDrops.listen((_) => controller.handleOwnedDrop()),
    ];
    if (connectivity != null) {
      subscriptions.add(
        connectivity.onChanged.listen(controller.handleConnectivityChange),
      );
    }

    final selectionCubit = ConnectionSelectionCubit();

    final routingBloc = RoutingBloc(
      loadRouting: LoadRoutingSnapshotUseCase(routingEngine),
      setMode: SetRoutingModeUseCase(routingEngine),
      setPreset: SetRoutingPresetUseCase(routingEngine),
      addRule: AddRoutingRuleUseCase(routingEngine),
      removeRule: RemoveRoutingRuleUseCase(routingEngine),
      resetRouting: ResetRoutingUseCase(routingEngine),
    )..add(const RoutingLoadRequested());

    // Load prefs / profiles before first frame (Servers tab needs the list).
    await vpnBloc.restoreFromOs();
    unawaited(vpnBloc.refreshDueSubscriptions());
    final lastLink = vpnBloc.state.activeShareLink;
    selectionCubit.selectMatchingLink(vpnBloc.state.savedProfiles, lastLink);

    return AppDependencies._(
      prefs: prefs,
      vpnConnectionBloc: vpnBloc,
      settingsBloc: settingsBloc,
      connectionSelectionCubit: selectionCubit,
      routingBloc: routingBloc,
      tunnel: tunnel,
      subscriptions: subscriptions,
    );
  }

  Future<void> dispose() async {
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
    await connectionSelectionCubit.close();
    await routingBloc.close();
    await vpnConnectionBloc.close();
    await settingsBloc.close();
  }
}

ProcessRestarter _platformRestarter(SystemTunnel tunnel) {
  if (Platform.isAndroid) return AndroidProcessRestarter();
  if (Platform.isWindows) return WindowsProcessRestarter();
  if (Platform.isMacOS) return MacOSProcessRestarter();
  if (!tunnel.isSupported) return MessageProcessRestarter();
  return MessageProcessRestarter();
}
