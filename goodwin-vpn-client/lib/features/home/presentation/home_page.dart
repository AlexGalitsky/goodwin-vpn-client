import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/ui_mode.dart';
import '../../../l10n/l10n_extension.dart';
import '../../../l10n/quota_copy.dart';
import '../../../session/saved_profile.dart';
import '../../../session/subscription.dart';
import '../../../session/tunnel_elevation.dart';
import '../../../session/vpn_connection_state.dart';
import '../../../ui/ui.dart';
import '../../connection/domain/ping_sample.dart';
import '../../connection/domain/smart_connect.dart';
import '../../connection/presentation/bloc/connection_selection_cubit.dart';
import '../../logs/presentation/home_logs_sheet.dart';
import '../../onboarding/permission_explainer.dart';
import '../../routing/domain/models/routing_models.dart';
import '../../routing/domain/vpn_backend_capability.dart';
import '../../routing/domain/vpn_ui_features.dart';
import '../../routing/presentation/bloc/routing_bloc.dart';
import '../../servers/presentation/profile_display.dart';
import '../../settings/presentation/bloc/app_settings_bloc.dart';
import '../../vpn/presentation/bloc/vpn_connection_bloc.dart';
import 'default_share_link.dart';
import 'home_connect_link.dart';
import 'home_network_copy.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.restoreOnStart = true});

  /// Tests set false so a seeded error state is not overwritten by OS restore.
  final bool restoreOnStart;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    if (widget.restoreOnStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _restore());
    }
  }

  Future<void> _restore() async {
    final vpn = context.read<VpnConnectionBloc>();
    await vpn.restoreFromOs();
    if (!mounted) return;
    var link = vpn.state.activeShareLink?.trim();
    if (link == null || link.isEmpty) {
      final fallback = loadDefaultShareLink();
      if (fallback != null && fallback.isNotEmpty) {
        await vpn.selectShareLink(fallback);
        if (!mounted) return;
        link = fallback;
      }
    }
    context.read<ConnectionSelectionCubit>().selectMatchingLink(
      vpn.state.savedProfiles,
      link,
    );
  }

  @override
  Widget build(BuildContext context) {
    final advanced =
        context.watch<AppSettingsBloc>().state.uiMode == UiMode.advanced;
    final selection = context.watch<ConnectionSelectionCubit>().state;

    return BlocBuilder<VpnConnectionBloc, VpnConnectionState>(
      builder: (context, conn) {
        final picking = conn.smartConnect && selection.pinging;
        final busy =
            conn.phase == ConnectionPhase.connecting ||
            conn.phase == ConnectionPhase.disconnecting ||
            picking;
        final connected = conn.phase == ConnectionPhase.connected;
        final error = conn.phase == ConnectionPhase.error;
        final vpn = context.read<VpnConnectionBloc>();
        var connectLink = resolveHomeConnectLink(
          savedProfiles: conn.savedProfiles,
          selectedProfileId: selection.selectedProfileId,
          activeShareLink: conn.activeShareLink,
        );
        if (!connected && conn.smartConnect) {
          final smart = resolveSmartConnectProfile(
            savedProfiles: conn.savedProfiles,
            selectedProfileId: selection.selectedProfileId,
            activeShareLink: conn.activeShareLink,
            pingById: selection.pingByProfileId,
          );
          if (smart != null) connectLink = smart.link;
        }
        final displayLink = connected
            ? (conn.activeShareLink ?? connectLink)
            : connectLink;
        final selectedProfile = conn.savedProfiles
            .where((p) => p.link == displayLink)
            .firstOrNull;
        final l10n = context.l10n;
        final profileLabel = selectedProfile != null
            ? profileDisplayName(selectedProfile)
            : (displayLink == null || displayLink.isEmpty
                  ? l10n.noProfile
                  : shareLinkShortLabel(displayLink));
        final gw = context.gw;
        final hasProfile = connectLink != null && connectLink.isNotEmpty;
        final networkCopy = homeNetworkCopy(
          l10n: l10n,
          connected: connected,
          busy: busy,
          tunnelSupported: vpn.tunnelSupported,
          error: error,
        );
        final quotaSub = quotaSubscriptionFor(
          subscriptions: conn.subscriptions,
          profile: selectedProfile,
        );
        final quotaLine = quotaSub?.userinfo == null
            ? ''
            : quotaDisplayLine(l10n, quotaSub!.userinfo!);
        final phaseAccent = connected
            ? gw.success
            : (busy
                ? gw.warning
                : (error ? Theme.of(context).colorScheme.error : gw.accent));
        final phaseTint = connected
            ? gw.successMuted
            : (busy
                ? gw.warning.withValues(alpha: 0.12)
                : (error
                    ? Theme.of(context).colorScheme.error.withValues(alpha: 0.1)
                    : gw.accentMuted));
        final hostHint = selectedProfile == null
            ? null
            : shareLinkShortLabel(selectedProfile.link);

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                GwContentWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GwPageHeader(
                        eyebrow: l10n.navHome,
                        title: l10n.appTitle,
                        description: networkCopy.subtitle,
                      ),
                      if (conn.subscriptions.any((s) => s.revoked))
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: _RevokedBanner(
                            onFix: () => context.go('/servers'),
                          ),
                        ),
                      if (quotaSub != null &&
                          shouldWarnExpire(quotaSub.userinfo))
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: GwExpireBanner(
                            label: expireWarningLabel(
                                  l10n,
                                  quotaSub.userinfo,
                                ) ??
                                '',
                            onTap: () => context.go('/servers'),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            if (!hasProfile)
                              GwCard(
                                borderColor: gw.accent.withValues(alpha: 0.35),
                                tintColor: gw.accentMuted,
                                child: Column(
                                  children: [
                                    Text(
                                      l10n.addProfileToConnect,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      l10n.addProfileToConnectHint,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 14),
                                    FilledButton.icon(
                                      onPressed: () => context.go('/servers'),
                                      icon: const Icon(Icons.add, size: 18),
                                      label: Text(l10n.addProfile),
                                    ),
                                  ],
                                ),
                              )
                            else ...[
                              GwCard(
                                borderColor:
                                    phaseAccent.withValues(alpha: 0.45),
                                tintColor: phaseTint,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                l10n.networkStatus,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                networkCopy.title,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                        GwStatusPill(
                                          label:
                                              _statusLabel(conn.phase, l10n),
                                          active: connected,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    GwConnectButton(
                                      connected: connected,
                                      busy: busy,
                                      onPressed: busy
                                          ? null
                                          : () => unawaited(
                                                _onConnectPressed(
                                                  vpn: vpn,
                                                  conn: conn,
                                                  connected: connected,
                                                  connectLink: connectLink,
                                                ),
                                              ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      connected
                                          ? l10n.tapToDisconnect
                                          : (error
                                              ? l10n.tapToRetry
                                              : l10n.tapToConnect),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(color: gw.textSecondary),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      networkCopy.subtitle,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                      textAlign: TextAlign.center,
                                    ),
                                    if (quotaLine.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        quotaLine,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      Text(
                                        l10n.quotaScopeNote,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: gw.textMuted),
                                      ),
                                    ],
                                    if (connected) ...[
                                      const SizedBox(height: 16),
                                      Divider(color: gw.cardBorder),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _StatCell(
                                              value: shareLinkShortLabel(
                                                conn.activeShareLink ??
                                                    connectLink,
                                              ),
                                              label: l10n.statNode,
                                            ),
                                          ),
                                          Expanded(
                                            child: _StatCell(
                                              value: pingLabel(
                                                selectedProfile == null
                                                    ? null
                                                    : selection.pingByProfileId[
                                                        selectedProfile.id],
                                              ),
                                              label: l10n.statPing,
                                            ),
                                          ),
                                          Expanded(
                                            child: _UptimeCell(
                                              since: conn.connectedAt,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              GwSelectedProfileStrip(
                                title: profileLabel,
                                subtitle: hostHint,
                                protocolKind:
                                    displayLink == null || displayLink.isEmpty
                                        ? null
                                        : protocolKindForLink(displayLink),
                                actionLabel: conn.savedProfiles.isEmpty
                                    ? l10n.addProfile
                                    : l10n.switchProfile,
                                onTap: () {
                                  if (conn.savedProfiles.isEmpty) {
                                    context.go('/servers');
                                    return;
                                  }
                                  _pickSavedProfile(
                                    context,
                                    conn,
                                    canSwitch: !busy,
                                  );
                                },
                                onChange: () => context.go('/servers'),
                              ),
                            ],
                            const SizedBox(height: 16),
                            const _RoutingChip(),
                            if (advanced) ...[
                              const SizedBox(height: 16),
                              GwCard(
                                padding: EdgeInsets.zero,
                                child: GwSettingsRow(
                                  title: l10n.sessionLogs,
                                  subtitle: conn.logs.isEmpty
                                      ? l10n.noLinesYet
                                      : l10n.logLinesCount(conn.logs.length),
                                  trailing: Icon(
                                    Icons.notes_outlined,
                                    color: context.gw.textMuted,
                                  ),
                                  onTap: () => showHomeLogsSheet(context),
                                ),
                              ),
                            ],
                            if (conn.elevationRequired) ...[
                              const SizedBox(height: 16),
                              _ElevationBanner(
                                message: conn.message,
                                onRequestElevation: () async {
                                  final ok = await vpn.requestElevation();
                                  if (!context.mounted) return;
                                  if (!ok) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(l10n.uacDeclined),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                            if (conn.message.isNotEmpty &&
                                !conn.elevationRequired) ...[
                              const SizedBox(height: 12),
                              Text(
                                OnDemandDisarmFailed.matches(conn.message)
                                    ? l10n.killSwitchIosDisconnectFailed
                                    : conn.message,
                                style:
                                    Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onConnectPressed({
    required VpnConnectionBloc vpn,
    required VpnConnectionState conn,
    required bool connected,
    required String? connectLink,
  }) async {
    if (!connected) {
      final settings = context.read<AppSettingsBloc>().state;
      if (vpn.tunnelSupported && !settings.vpnExplainerSeen) {
        final go = await showPermissionExplainer(
          context: context,
          title: context.l10n.vpnExplainerTitle,
          body: context.l10n.vpnExplainerBody,
          continueLabel: context.l10n.vpnExplainerContinue,
        );
        if (go != true || !mounted) return;
        context.read<AppSettingsBloc>().add(const AppSettingsVpnExplainerSeen());
      }
    }
    if (connected) {
      final ks = context.read<AppSettingsBloc>().state.killSwitch;
      if (ks && Platform.isAndroid) {
        final go = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(ctx.l10n.killSwitchDisconnectTitle),
            content: Text(ctx.l10n.killSwitchDisconnectBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(ctx.l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(ctx.l10n.killSwitchDisconnectConfirm),
              ),
            ],
          ),
        );
        if (go != true || !mounted) return;
      }
      vpn.disconnect();
      return;
    }
    await _connectWithSmart(vpn, connectLink);
  }

  Future<void> _connectWithSmart(
    VpnConnectionBloc vpn,
    String? connectLink,
  ) async {
    var link = connectLink;
    if (vpn.state.smartConnect) {
      final selection = context.read<ConnectionSelectionCubit>();
      final peers = subscriptionPeers(
        anchor: anchorProfileForConnect(
          savedProfiles: vpn.state.savedProfiles,
          selectedProfileId: selection.state.selectedProfileId,
          activeShareLink: vpn.state.activeShareLink,
        ),
        savedProfiles: vpn.state.savedProfiles,
      );
      if (peers.length > 1) {
        await selection.pingProfiles(peers);
        if (!mounted) return;
        final best = pickLowestPingProfile(
          peers,
          selection.state.pingByProfileId,
        );
        if (best != null) {
          selection.selectProfile(best.id);
          await vpn.selectShareLink(best.link);
          link = best.link;
        }
      }
    }
    if (link == null || link.isEmpty) return;
    await vpn.connect(link);
  }

  Future<void> _pickSavedProfile(
    BuildContext context,
    VpnConnectionState conn, {
    required bool canSwitch,
  }) async {
    const manage = Object();
    final chosen = await showModalBottomSheet<Object>(
      context: context,
      builder: (ctx) {
        final current = resolveHomeConnectLink(
          savedProfiles: conn.savedProfiles,
          selectedProfileId: ctx
              .read<ConnectionSelectionCubit>()
              .state
              .selectedProfileId,
          activeShareLink: conn.activeShareLink,
        );
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  ctx.l10n.switchProfile,
                  style: Theme.of(ctx).textTheme.titleMedium,
                ),
              ),
              for (final profile in conn.savedProfiles)
                ListTile(
                  title: Text(profileDisplayName(profile)),
                  subtitle: Text(
                    shareLinkShortLabel(profile.link),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (protocolKindForLink(profile.link) case final kind?)
                        GwProtocolChip(kind),
                      if (current == profile.link) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.check, color: ctx.gw.accent),
                      ],
                    ],
                  ),
                  onTap: () => Navigator.of(ctx).pop(profile),
                ),
              ListTile(
                leading: const Icon(Icons.tune_outlined),
                title: Text(ctx.l10n.manageProfiles),
                onTap: () => Navigator.of(ctx).pop(manage),
              ),
            ],
          ),
        );
      },
    );
    if (!context.mounted || chosen == null) return;
    if (chosen == manage) {
      context.go('/servers');
      return;
    }
    if (chosen is! SavedProfile || !canSwitch) return;
    context.read<ConnectionSelectionCubit>().selectProfile(chosen.id);
    if (conn.phase != ConnectionPhase.connected) {
      await context.read<VpnConnectionBloc>().selectShareLink(chosen.link);
    }
  }

  String _statusLabel(ConnectionPhase phase, AppLocalizations l10n) =>
      switch (phase) {
        ConnectionPhase.idle => l10n.statusOffline,
        ConnectionPhase.connecting => l10n.statusConnecting,
        ConnectionPhase.connected => l10n.statusConnected,
        ConnectionPhase.disconnecting => l10n.statusDisconnecting,
        ConnectionPhase.error => l10n.statusError,
      };
}

class _RoutingChip extends StatelessWidget {
  const _RoutingChip();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VpnConnectionBloc, VpnConnectionState>(
      buildWhen: (prev, next) => prev.activeShareLink != next.activeShareLink,
      builder: (context, conn) {
        return BlocBuilder<RoutingBloc, RoutingState>(
          buildWhen: (prev, next) => prev.snapshot.mode != next.snapshot.mode,
          builder: (context, routing) {
            final l10n = context.l10n;
            final features = VpnUiFeatures.resolve(
              isAndroid: Platform.isAndroid,
              isIos: Platform.isIOS,
              tunnelSupported: context
                  .read<VpnConnectionBloc>()
                  .tunnelSupported,
              backend: vpnBackendKindForLink(conn.activeShareLink),
            );
            final shown = features.displayMode(routing.snapshot.mode);
            final mode = switch (shown) {
              RoutingMode.global => l10n.routingModeGlobal,
              RoutingMode.rules => l10n.routingModeRules,
              RoutingMode.direct => l10n.routingModeDirect,
            };
            return GwCard(
              padding: EdgeInsets.zero,
              child: GwSettingsRow(
                title: l10n.routing,
                subtitle: l10n.routingChipSubtitle(mode),
                trailing: Icon(
                  Icons.chevron_right_rounded,
                  color: context.gw.textMuted,
                ),
                onTap: () => context.go('/routes'),
              ),
            );
          },
        );
      },
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.value, required this.label, this.emphasis});

  final String value;
  final String label;
  final Color? emphasis;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: emphasis ?? context.gw.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _UptimeCell extends StatefulWidget {
  const _UptimeCell({required this.since});

  final DateTime? since;

  @override
  State<_UptimeCell> createState() => _UptimeCellState();
}

class _UptimeCellState extends State<_UptimeCell> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.since != null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void didUpdateWidget(covariant _UptimeCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.since != widget.since) {
      _timer?.cancel();
      _timer = widget.since == null
          ? null
          : Timer.periodic(const Duration(seconds: 1), (_) {
              if (mounted) setState(() {});
            });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final since = widget.since;
    return _StatCell(
      value: since == null
          ? '—'
          : formatUptime(DateTime.now().difference(since)),
      label: context.l10n.statUptime,
      emphasis: context.gw.success,
    );
  }
}

class _RevokedBanner extends StatelessWidget {
  const _RevokedBanner({required this.onFix});

  final VoidCallback onFix;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GwCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.link_off, color: colors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.l10n.revokedTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.revokedBody,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.tonal(
                    onPressed: onFix,
                    child: Text(context.l10n.openProfiles),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ElevationBanner extends StatelessWidget {
  const _ElevationBanner({
    required this.message,
    required this.onRequestElevation,
  });

  final String message;
  final VoidCallback onRequestElevation;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GwCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.admin_panel_settings_outlined, color: colors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.l10n.elevationTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(message, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.tonal(
                    onPressed: onRequestElevation,
                    child: Text(context.l10n.runAsAdministrator),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
