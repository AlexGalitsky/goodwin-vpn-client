import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/l10n_extension.dart';
import '../../../session/vpn_connection_state.dart';
import '../../../ui/ui.dart';
import '../../vpn/presentation/bloc/vpn_connection_bloc.dart';
import '../domain/models/routing_models.dart';
import '../domain/vpn_backend_capability.dart';
import '../domain/vpn_ui_features.dart';
import 'bloc/routing_bloc.dart';
import 'routes_labels.dart';

/// Custom domain rules + always-exclude CIDR — Advanced only.
class RoutesAdvancedPage extends StatefulWidget {
  const RoutesAdvancedPage({super.key});

  @override
  State<RoutesAdvancedPage> createState() => _RoutesAdvancedPageState();
}

class _RoutesAdvancedPageState extends State<RoutesAdvancedPage> {
  final _matcherController = TextEditingController();
  final _excludeController = TextEditingController();
  var _action = RoutingAction.proxy;
  var _seeded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seeded) return;
    _seeded = true;
    _excludeController.text =
        context.read<VpnConnectionBloc>().state.excludeRoutes.join('\n');
  }

  @override
  void dispose() {
    _matcherController.dispose();
    _excludeController.dispose();
    super.dispose();
  }

  void _addRule(VpnUiFeatures features) {
    final matcher = _matcherController.text.trim();
    if (matcher.isEmpty) return;
    final action = features.allowedActions.contains(_action)
        ? _action
        : RoutingAction.proxy;
    context.read<RoutingBloc>().add(
          RoutingRuleAdded(matcher: matcher, action: action),
        );
    _matcherController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(context.l10n.customRules),
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<RoutingBloc, RoutingState>(
        builder: (context, state) {
          final snapshot = state.snapshot;
          return BlocBuilder<VpnConnectionBloc, VpnConnectionState>(
            buildWhen: (prev, next) =>
                prev.activeShareLink != next.activeShareLink ||
                prev.excludeRoutes != next.excludeRoutes ||
                prev.phase != next.phase,
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

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  if (features.excludeCidr) ...[
                    Text(
                      context.l10n.alwaysExcludeCidr,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.alwaysExcludeHint,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Builder(
                      builder: (context) {
                        final canEdit =
                            conn.phase != ConnectionPhase.connecting &&
                                conn.phase != ConnectionPhase.disconnecting &&
                                conn.phase != ConnectionPhase.connected;
                        return TextField(
                          controller: _excludeController,
                          minLines: 2,
                          maxLines: 4,
                          enabled: canEdit,
                          onTapOutside: gwUnfocusOnTapOutside,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                            hintText: context.l10n.cidrHint,
                            alignLabelWithHint: true,
                          ),
                          onChanged: canEdit
                              ? (_) {
                                  final routes = _excludeController.text
                                      .split(RegExp(r'[\r\n,;]+'))
                                      .map((e) => e.trim())
                                      .where((e) => e.isNotEmpty)
                                      .toList();
                                  context
                                      .read<VpnConnectionBloc>()
                                      .setExcludeRoutes(routes);
                                }
                              : null,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                  if (features.rulesRouting) ...[
                    Text(
                      context.l10n.customRules,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      features.blockRouting
                          ? context.l10n.customRulesHint
                          : context.l10n.customRulesHintTrustTunnel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _matcherController,
                      enabled: rulesMode,
                      onTapOutside: gwUnfocusOnTapOutside,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: context.l10n.matcher,
                        hintText: context.l10n.matcherHint,
                        border: const OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _addRule(features),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        for (final action in features.allowedActions)
                          ChoiceChip(
                            label: Text(action.name),
                            selected: _action == action,
                            onSelected: !rulesMode
                                ? null
                                : (_) => setState(() => _action = action),
                          ),
                        FilledButton.tonal(
                          onPressed:
                              rulesMode ? () => _addRule(features) : null,
                          child: Text(context.l10n.addRule),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (snapshot.customRules.isEmpty)
                      Text(
                        context.l10n.noCustomRules,
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    else
                      for (final rule in snapshot.customRules)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(rule.matcher),
                          subtitle: Text(
                            !features.blockRouting &&
                                    rule.action == RoutingAction.block
                                ? context.l10n.routingRuleBlockSkipped
                                : rule.action == RoutingAction.direct &&
                                        looksLikeIpOrCidr(rule.matcher)
                                    ? context.l10n.osExclude(rule.action.name)
                                    : rule.action.name,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () {
                              context.read<RoutingBloc>().add(
                                    RoutingRuleRemoved(rule.id),
                                  );
                            },
                          ),
                        ),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }
}
