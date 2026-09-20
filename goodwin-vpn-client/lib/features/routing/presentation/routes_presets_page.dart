import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/l10n_extension.dart';
import '../../../session/goodwin_service.dart';
import '../../../session/subscription.dart';
import '../../../session/vpn_connection_state.dart';
import '../../../ui/ui.dart';
import '../../split/data/android_split_client.dart';
import '../../split/domain/split_apps.dart';
import '../../vpn/presentation/bloc/vpn_connection_bloc.dart';
import '../domain/models/routing_models.dart';
import '../domain/vpn_backend_capability.dart';
import '../domain/vpn_ui_features.dart';
import 'bloc/routing_bloc.dart';
import 'routes_labels.dart';

/// Presets + per-app bypass — pushed from Rules hub.
class RoutesPresetsPage extends StatelessWidget {
  const RoutesPresetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(context.l10n.presets),
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<RoutingBloc, RoutingState>(
        builder: (context, state) {
          final snapshot = state.snapshot;
          return BlocBuilder<VpnConnectionBloc, VpnConnectionState>(
            buildWhen: (prev, next) =>
                prev.activeShareLink != next.activeShareLink ||
                prev.disallowedPackages != next.disallowedPackages ||
                prev.subscriptions != next.subscriptions ||
                prev.savedProfiles != next.savedProfiles,
            builder: (context, conn) {
              final backend = vpnBackendKindForLink(conn.activeShareLink);
              final features = VpnUiFeatures.resolve(
                isAndroid: Platform.isAndroid,
                tunnelSupported:
                    context.read<VpnConnectionBloc>().tunnelSupported,
                backend: backend,
              );
              final rulesMode =
                  features.displayMode(snapshot.mode) == RoutingMode.rules;
              final geoSub = subscriptionForShareLink(
                subscriptions: conn.subscriptions,
                savedProfiles: conn.savedProfiles,
                shareLink: conn.activeShareLink,
              );
              final geoPacks =
                  geoSub?.features.contains(kGoodwinFeatureGeoPacks) == true;

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                children: [
                  for (final preset in RoutingPresetId.values)
                    if (routingPresetVisible(
                      preset,
                      features,
                      geoPacks: geoPacks,
                      backend: backend,
                    ))
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          routingPresetTitle(
                            context.l10n,
                            preset,
                            geoPacks: geoPacks,
                            backend: backend,
                          ),
                        ),
                        subtitle: Text(
                          routingPresetSubtitle(
                            context.l10n,
                            preset,
                            features,
                            geoPacks: geoPacks,
                            backend: backend,
                          ),
                        ),
                        value: snapshot.isPresetEnabled(preset),
                        onChanged: state.loading ||
                                (preset != RoutingPresetId.protectBanking &&
                                    !rulesMode) ||
                                !routingPresetEnabled(
                                  preset,
                                  features,
                                  geoPacks: geoPacks,
                                  backend: backend,
                                )
                            ? null
                            : (enabled) {
                                context.read<RoutingBloc>().add(
                                      RoutingPresetToggled(
                                        id: preset,
                                        enabled: enabled,
                                      ),
                                    );
                              },
                      ),
                  if (features.perAppSplit)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(context.l10n.appsSkipVpn),
                      subtitle: Text(
                        conn.disallowedPackages.isEmpty
                            ? context.l10n.appsSkipVpnEmpty
                            : context.l10n.appsSkipVpnSelected(
                                conn.disallowedPackages.length,
                              ),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _pickBypassApps(context, conn),
                    ),
                  if (!rulesMode && features.rulesRouting)
                    Text(
                      context.l10n.switchToRulesForPresets,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

Future<void> _pickBypassApps(
  BuildContext context,
  VpnConnectionState conn,
) async {
  final selected = conn.disallowedPackages.toSet();
  List<InstalledApp> apps;
  try {
    apps = await AndroidSplitClient().listLaunchableApps();
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    return;
  }
  if (!context.mounted) return;
  final query = TextEditingController();
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setSheet) {
          final q = query.text.trim().toLowerCase();
          final visible = [
            for (final app in apps)
              if (q.isEmpty ||
                  app.label.toLowerCase().contains(q) ||
                  app.packageName.toLowerCase().contains(q))
                app,
          ];
          return SizedBox(
            height: MediaQuery.sizeOf(ctx).height * 0.75,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: TextField(
                    controller: query,
                    onTapOutside: gwUnfocusOnTapOutside,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: ctx.l10n.searchApps,
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (_) => setSheet(() {}),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: visible.length,
                    itemBuilder: (ctx, i) {
                      final app = visible[i];
                      final on = selected.contains(app.packageName);
                      return CheckboxListTile(
                        value: on,
                        title: Text(app.label),
                        subtitle: Text(app.packageName),
                        onChanged: (value) {
                          setSheet(() {
                            if (value == true) {
                              selected.add(app.packageName);
                            } else {
                              selected.remove(app.packageName);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: FilledButton(
                    onPressed: () {
                      context.read<VpnConnectionBloc>().setDisallowedPackages(
                            selected.toList()..sort(),
                          );
                      Navigator.of(ctx).pop();
                    },
                    child: Text(ctx.l10n.save),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
  query.dispose();
}
