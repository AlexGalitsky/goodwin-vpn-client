import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/ui_mode.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/logs/presentation/logs_page.dart';
import '../../features/onboarding/onboarding_page.dart';
import '../../features/routing/presentation/routes_page.dart';
import '../../features/servers/presentation/servers_page.dart';
import '../../features/settings/presentation/bloc/app_settings_bloc.dart';
import '../../features/settings/presentation/settings_page.dart';
import 'scaffold_with_nav_bar.dart';

final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _homeKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _serversKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _routesKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _logsKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _settingsKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter({required Listenable refreshListenable}) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/home',
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final settings = context.read<AppSettingsBloc>().state;
      final path = state.uri.path;
      if (!settings.onboardingCompleted && path != '/onboarding') {
        return '/onboarding';
      }
      if (settings.onboardingCompleted && path == '/onboarding') {
        return '/home';
      }
      if (path == '/logs') {
        if (settings.uiMode != UiMode.advanced) return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeKey,
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _serversKey,
            routes: [
              GoRoute(
                path: '/servers',
                builder: (context, state) => const ServersPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _routesKey,
            routes: [
              GoRoute(
                path: '/routes',
                builder: (context, state) => const RoutesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _logsKey,
            routes: [
              GoRoute(
                path: '/logs',
                builder: (context, state) => const LogsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _settingsKey,
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
