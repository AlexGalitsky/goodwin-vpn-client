import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/ui_mode.dart';
import '../../features/settings/presentation/bloc/app_settings_bloc.dart';
import '../../features/vpn/presentation/bloc/vpn_connection_bloc.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/l10n_extension.dart';
import '../../session/vpn_connection_state.dart';
import '../../ui/ui.dart';

/// Adaptive shell: bottom nav on phone, side rail/sidebar on tablet/desktop.
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  /// Branch order: 0 Home, 1 Servers, 2 Routes, 3 Logs, 4 Settings.
  static const _branchHome = 0;
  static const _branchServers = 1;
  static const _branchRoutes = 2;
  static const _branchLogs = 3;
  static const _branchSettings = 4;

  static List<GwNavItem> navItems(
    AppLocalizations l10n, {
    required bool advanced,
  }) {
    return [
      GwNavItem(
        icon: Icons.bolt_outlined,
        selectedIcon: Icons.bolt_rounded,
        label: l10n.navHome,
      ),
      GwNavItem(
        icon: Icons.dns_outlined,
        selectedIcon: Icons.dns_rounded,
        label: l10n.navProfiles,
      ),
      GwNavItem(
        icon: Icons.alt_route_outlined,
        selectedIcon: Icons.alt_route_rounded,
        label: l10n.navRules,
      ),
      if (advanced)
        GwNavItem(
          icon: Icons.terminal_outlined,
          selectedIcon: Icons.terminal_rounded,
          label: l10n.navLogs,
        ),
      GwNavItem(
        icon: Icons.settings_outlined,
        selectedIcon: Icons.settings_rounded,
        label: l10n.navSettings,
      ),
    ];
  }

  void _onTap(BuildContext context, int barIndex) {
    gwDismissKeyboard();
    final advanced =
        context.read<AppSettingsBloc>().state.uiMode == UiMode.advanced;
    final branchIndex = advanced
        ? barIndex
        : switch (barIndex) {
            0 => _branchHome,
            1 => _branchServers,
            2 => _branchRoutes,
            3 => _branchSettings,
            _ => _branchHome,
          };
    navigationShell.goBranch(
      branchIndex,
      initialLocation: branchIndex == navigationShell.currentIndex,
    );
  }

  int _barIndex(bool advanced) {
    final branch = navigationShell.currentIndex;
    if (advanced) return branch;
    return switch (branch) {
      _branchHome => 0,
      _branchServers => 1,
      _branchRoutes => 2,
      _branchLogs => 0,
      _branchSettings => 3,
      _ => 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final advanced =
        context.watch<AppSettingsBloc>().state.uiMode == UiMode.advanced;
    final l10n = context.l10n;
    final items = navItems(l10n, advanced: advanced);
    final barIndex = _barIndex(advanced).clamp(0, items.length - 1);
    final window = GwBreakpoints.of(context);
    final side = GwBreakpoints.useSideNav(window);

    final body = navigationShell;
    final scaffold = side
        ? Row(
            children: [
              GwSideNav(
                items: items,
                currentIndex: barIndex,
                onTap: (i) => _onTap(context, i),
                extended: GwBreakpoints.sideNavExtended(window),
                footer: const _SessionFooter(),
              ),
              Expanded(child: body),
            ],
          )
        : body;

    return GwCanvas(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: scaffold,
        bottomNavigationBar: side
            ? null
            : GwBottomNav(
                items: items,
                currentIndex: barIndex,
                onTap: (i) => _onTap(context, i),
              ),
      ),
    );
  }
}

class _SessionFooter extends StatelessWidget {
  const _SessionFooter();

  @override
  Widget build(BuildContext context) {
    final gw = context.gw;
    final phase = context.watch<VpnConnectionBloc>().state.phase;
    final connected = phase == ConnectionPhase.connected;
    final connecting = phase == ConnectionPhase.connecting;
    final disconnecting = phase == ConnectionPhase.disconnecting;
    final color = connected
        ? gw.success
        : (connecting || disconnecting)
            ? gw.warning
            : gw.textMuted;
    final label = connected
        ? context.l10n.statusConnected
        : connecting
            ? context.l10n.statusConnecting
            : disconnecting
                ? context.l10n.statusDisconnecting
                : context.l10n.homeReadyTitle;

    if (!GwBreakpoints.sideNavExtended(GwBreakpoints.of(context))) {
      return Tooltip(
        message: label,
        child: Center(
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: gw.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: gw.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: gw.textSecondary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
