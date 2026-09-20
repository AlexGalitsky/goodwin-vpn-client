import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/ui_mode.dart';
import '../../../l10n/l10n_extension.dart';
import '../../../session/vpn_connection_state.dart';
import '../../../ui/ui.dart';
import '../../settings/presentation/bloc/app_settings_bloc.dart';
import '../../vpn/presentation/bloc/vpn_connection_bloc.dart';
import '../domain/models/routing_models.dart';
import '../domain/vpn_backend_capability.dart';
import '../domain/vpn_ui_features.dart';
import 'bloc/routing_bloc.dart';
import 'routes_advanced_page.dart';
import 'routes_labels.dart';
import 'routes_presets_page.dart';

/// Rules hub — mode + navigation to presets / advanced.
class RoutesPage extends StatefulWidget {
  const RoutesPage({super.key});

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<RoutingBloc>().add(const RoutingLoadRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    final advanced =
        context.watch<AppSettingsBloc>().state.uiMode == UiMode.advanced;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            GwPageHeader(
              eyebrow: context.l10n.rulesEyebrow,
              title: context.l10n.rulesTitle,
              trailing: GwIconButton(
                tooltip: context.l10n.reset,
                icon: Icons.restart_alt,
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(ctx.l10n.reset),
                      content: Text(ctx.l10n.resetRulesConfirm),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text(ctx.l10n.cancel),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text(ctx.l10n.reset),
                        ),
                      ],
                    ),
                  );
                  if (ok != true || !context.mounted) return;
                  context.read<RoutingBloc>().add(
                        const RoutingResetRequested(),
                      );
                },
              ),
            ),
            Expanded(
              child: BlocConsumer<RoutingBloc, RoutingState>(
                listenWhen: (prev, next) =>
                    prev.actionError != next.actionError &&
                    next.actionError != null,
                listener: (context, state) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${state.actionError}')),
                  );
                  context.read<RoutingBloc>().add(
                        const RoutingClearActionError(),
                      );
                },
                builder: (context, state) {
                  final snapshot = state.snapshot;
                  return BlocBuilder<VpnConnectionBloc, VpnConnectionState>(
                    buildWhen: (prev, next) =>
                        prev.activeShareLink != next.activeShareLink,
                    builder: (context, conn) {
                      final backend =
                          vpnBackendKindForLink(conn.activeShareLink);
                      final features = VpnUiFeatures.resolve(
                        isAndroid: Platform.isAndroid,
                        tunnelSupported: context
                            .read<VpnConnectionBloc>()
                            .tunnelSupported,
                        backend: backend,
                      );
                      final displayed = features.displayMode(snapshot.mode);

                      return ListView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        children: [
                          _CapabilityBanner(
                            backend: backend,
                            warning: !features.rulesRouting,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.l10n.mode,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          SegmentedButton<RoutingMode>(
                            segments: [
                              ButtonSegment(
                                value: RoutingMode.global,
                                label: Text(context.l10n.routingModeGlobal),
                              ),
                              if (features.rulesRouting)
                                ButtonSegment(
                                  value: RoutingMode.rules,
                                  label: Text(context.l10n.routingModeRules),
                                ),
                              if (features.directRouting)
                                ButtonSegment(
                                  value: RoutingMode.direct,
                                  label: Text(context.l10n.routingModeDirect),
                                ),
                            ],
                            selected: {displayed},
                            onSelectionChanged: state.loading
                                ? null
                                : (next) {
                                    if (next.isEmpty) return;
                                    final mode = next.first;
                                    if (!features.allowsMode(mode)) return;
                                    context.read<RoutingBloc>().add(
                                          RoutingModeChanged(mode),
                                        );
                                  },
                          ),
                          const SizedBox(height: 8),
                          Text(
                            routingModeHint(
                              context.l10n,
                              displayed,
                              features,
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).hintColor,
                                ),
                          ),
                          const SizedBox(height: 20),
                          GwCard(
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                GwSettingsRow(
                                  title: context.l10n.presets,
                                  subtitle: context.l10n.presetsHubSubtitle,
                                  trailing: Icon(
                                    Icons.chevron_right,
                                    color: context.gw.textMuted,
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (_) =>
                                            const RoutesPresetsPage(),
                                      ),
                                    );
                                  },
                                ),
                                if (advanced &&
                                    (features.rulesRouting ||
                                        features.excludeCidr)) ...[
                                  Divider(
                                    color: context.gw.cardBorder,
                                    height: 1,
                                  ),
                                  GwSettingsRow(
                                    title: context.l10n.customRules,
                                    subtitle:
                                        context.l10n.customRulesHubSubtitle,
                                    trailing: Icon(
                                      Icons.chevron_right,
                                      color: context.gw.textMuted,
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (_) =>
                                              const RoutesAdvancedPage(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (!advanced &&
                              (features.excludeCidr || features.rulesRouting))
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text(
                                context.l10n.enableAdvancedForRouting,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                              ),
                            ),
                          if (features.excludeCidr)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                context.l10n.alwaysExcludeMerged,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CapabilityBanner extends StatelessWidget {
  const _CapabilityBanner({required this.backend, required this.warning});

  final VpnBackendKind backend;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: warning
          ? scheme.errorContainer.withValues(alpha: 0.55)
          : scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              warning ? Icons.warning_amber_outlined : Icons.info_outline,
              size: 20,
              color: warning
                  ? scheme.onErrorContainer
                  : scheme.onSurfaceVariant,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                switch (backend) {
                  VpnBackendKind.xray => context.l10n.routingBannerXray,
                  VpnBackendKind.hysteria => context.l10n.routingBannerHysteria,
                  VpnBackendKind.trustTunnel =>
                    context.l10n.routingBannerTrustTunnel,
                  VpnBackendKind.unknown => context.l10n.routingBannerUnknown,
                },
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: warning
                          ? scheme.onErrorContainer
                          : scheme.onSurfaceVariant,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
