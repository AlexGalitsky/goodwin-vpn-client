import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/config/locale_preference.dart';
import 'core/di/app_dependencies.dart';
import 'core/router/app_router.dart';
import 'features/connection/presentation/bloc/connection_selection_cubit.dart';
import 'features/routing/presentation/bloc/routing_bloc.dart';
import 'features/servers/presentation/import_link_binder.dart';
import 'features/settings/presentation/bloc/app_settings_bloc.dart';
import 'features/vpn/presentation/bloc/vpn_connection_bloc.dart';
import 'l10n/app_localizations.dart';
import 'ui/ui.dart';

class GoodwinVpnApp extends StatefulWidget {
  const GoodwinVpnApp({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<GoodwinVpnApp> createState() => _GoodwinVpnAppState();
}

class _GoodwinVpnAppState extends State<GoodwinVpnApp> {
  late final GoRouter _router;
  late final _RouterRefreshListenable _refresh;

  @override
  void initState() {
    super.initState();
    _refresh = _RouterRefreshListenable(widget.dependencies.settingsBloc);
    _router = createAppRouter(refreshListenable: _refresh);
  }

  @override
  void dispose() {
    _refresh.dispose();
    // Router has no dispose in go_router 17; drop refs.
    unawaited(widget.dependencies.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deps = widget.dependencies;
    return RepositoryProvider<SharedPreferences>.value(
      value: deps.prefs,
      child: MultiBlocProvider(
      providers: [
        BlocProvider<VpnConnectionBloc>.value(value: deps.vpnConnectionBloc),
        BlocProvider<AppSettingsBloc>.value(value: deps.settingsBloc),
        BlocProvider<ConnectionSelectionCubit>.value(
          value: deps.connectionSelectionCubit,
        ),
        BlocProvider<RoutingBloc>.value(value: deps.routingBloc),
      ],
      child: BlocBuilder<AppSettingsBloc, AppSettingsState>(
        buildWhen: (prev, next) =>
            prev.themePreference != next.themePreference ||
            prev.localePreference != next.localePreference,
        builder: (context, settings) {
          return MaterialApp.router(
            title: 'GoodWin VPN',
            debugShowCheckedModeBanner: false,
            theme: buildGwTheme(Brightness.light),
            darkTheme: buildGwTheme(Brightness.dark),
            themeMode: settings.themePreference.themeMode,
            locale: settings.localePreference.locale,
            localeResolutionCallback: localeResolutionCallback,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: _router,
            builder: (context, child) {
              final brightness = Theme.of(context).brightness;
              final colors = context.gw;
              final overlay = (brightness == Brightness.dark
                      ? SystemUiOverlayStyle.light
                      : SystemUiOverlayStyle.dark)
                  .copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: colors.navBar,
                systemNavigationBarIconBrightness: brightness == Brightness.dark
                    ? Brightness.light
                    : Brightness.dark,
              );
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: overlay,
                child: ImportLinkBinder(
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            },
          );
        },
      ),
      ),
    );
  }
}

class _RouterRefreshListenable extends ChangeNotifier {
  _RouterRefreshListenable(AppSettingsBloc settings) {
    _sub = settings.stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
