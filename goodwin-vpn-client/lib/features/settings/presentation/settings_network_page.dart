import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/dns_mode.dart';
import '../../../core/config/ui_mode.dart';
import '../../../l10n/l10n_extension.dart';
import '../../../ui/ui.dart';
import '../../routing/domain/vpn_backend_capability.dart';
import '../../routing/domain/vpn_ui_features.dart';
import '../../vpn/presentation/bloc/vpn_connection_bloc.dart';
import 'advanced_danger_badge.dart';
import 'bloc/app_settings_bloc.dart';

/// DNS / SOCKS / core tuning — pushed from Settings hub.
class SettingsNetworkPage extends StatefulWidget {
  const SettingsNetworkPage({super.key});

  @override
  State<SettingsNetworkPage> createState() => _SettingsNetworkPageState();
}

class _SettingsNetworkPageState extends State<SettingsNetworkPage> {
  final _dnsController = TextEditingController();
  final _socksPortController = TextEditingController();
  final _socksUserController = TextEditingController();
  final _socksPassController = TextEditingController();
  var _seeded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seeded) return;
    _seeded = true;
    final state = context.read<AppSettingsBloc>().state;
    final custom = state.dnsCustom;
    if (custom != null && custom.isNotEmpty) {
      _dnsController.text = custom;
    }
    _socksPortController.text = '${state.socksPort}';
    _socksUserController.text = state.socksUsername;
    _socksPassController.text = state.socksPassword;
  }

  @override
  void dispose() {
    _dnsController.dispose();
    _socksPortController.dispose();
    _socksUserController.dispose();
    _socksPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(context.l10n.dns),
        backgroundColor: Colors.transparent,
      ),
      body: BlocBuilder<AppSettingsBloc, AppSettingsState>(
        builder: (context, state) {
          final advanced = state.uiMode == UiMode.advanced;
          if (!advanced) {
            return Center(child: Text(context.l10n.advancedModeSubtitle));
          }
          final vpnBloc = context.watch<VpnConnectionBloc>();
          final features = VpnUiFeatures.resolve(
            isAndroid: Platform.isAndroid,
            isIos: Platform.isIOS,
            tunnelSupported: vpnBloc.tunnelSupported,
            backend: vpnBackendKindForLink(vpnBloc.state.activeShareLink),
          );

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              GwCard(
                padding: EdgeInsets.zero,
                child: GwSettingsRow(
                  title: context.l10n.dns,
                  subtitle: _dnsLabel(context, state.dnsMode),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: context.gw.textMuted,
                  ),
                  onTap: () => _pickDnsMode(context, state),
                ),
              ),
              if (state.dnsMode != DnsMode.system) ...[
                const SizedBox(height: 8),
                GwCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _dnsController,
                        onTapOutside: gwUnfocusOnTapOutside,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          labelText: context.l10n.dnsServerLabel,
                          hintText: state.dnsMode == DnsMode.doh
                              ? 'https://dns.example/dns-query'
                              : '1.1.1.1',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FilledButton.tonal(
                          onPressed: () {
                            final text = _dnsController.text.trim();
                            context.read<AppSettingsBloc>().add(
                                  AppSettingsVpnPreferencesUpdated(
                                    dnsCustom: text,
                                    clearDnsCustom: text.isEmpty,
                                  ),
                                );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(context.l10n.dnsSaved)),
                            );
                          },
                          child: Text(context.l10n.saveDns),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (features.xrayCoreTuning) ...[
                GwSectionLabel(context.l10n.coreTuning),
                GwCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      GwSettingsRow(
                        leading: AdvancedDangerBadge(
                          tooltip: context.l10n.advancedDangerTooltip,
                        ),
                        title: context.l10n.mux,
                        subtitle: context.l10n.muxSubtitle,
                        toggleValue: state.coreMux,
                        onToggle: (value) {
                          context.read<AppSettingsBloc>().add(
                                AppSettingsVpnPreferencesUpdated(
                                  coreMux: value,
                                ),
                              );
                        },
                      ),
                      Divider(color: context.gw.cardBorder, height: 1),
                      GwSettingsRow(
                        leading: AdvancedDangerBadge(
                          tooltip: context.l10n.advancedDangerTooltip,
                        ),
                        title: context.l10n.fragment,
                        subtitle: context.l10n.fragmentSubtitle,
                        toggleValue: state.coreFragment,
                        onToggle: (value) {
                          context.read<AppSettingsBloc>().add(
                                AppSettingsVpnPreferencesUpdated(
                                  coreFragment: value,
                                ),
                              );
                        },
                      ),
                    ],
                  ),
                ),
              ],
              GwSectionLabel(context.l10n.socksInbound),
              GwCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.socksInboundSubtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _socksPortController,
                      onTapOutside: gwUnfocusOnTapOutside,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: context.l10n.socksPort,
                        hintText: '10808',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _socksUserController,
                      onTapOutside: gwUnfocusOnTapOutside,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: context.l10n.socksUsername,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _socksPassController,
                      onTapOutside: gwUnfocusOnTapOutside,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: context.l10n.socksPassword,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FilledButton.tonal(
                        onPressed: () {
                          final port = int.tryParse(
                                _socksPortController.text.trim(),
                              ) ??
                              10808;
                          final user = _socksUserController.text.trim();
                          final pass = _socksPassController.text.trim();
                          context.read<AppSettingsBloc>().add(
                                AppSettingsVpnPreferencesUpdated(
                                  socksPort: port,
                                  socksUsername: user,
                                  socksPassword: pass,
                                  clearSocksUsername: user.isEmpty,
                                  clearSocksPassword: pass.isEmpty,
                                ),
                              );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(context.l10n.socksSaved)),
                          );
                        },
                        child: Text(context.l10n.saveSocks),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                features.xrayCoreTuning
                    ? context.l10n.dnsHintWithTuning
                    : context.l10n.dnsHintSimple,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
        },
      ),
    );
  }

  String _dnsLabel(BuildContext context, DnsMode mode) => switch (mode) {
        DnsMode.system => context.l10n.dnsSystem,
        DnsMode.custom => context.l10n.dnsCustom,
        DnsMode.doh => context.l10n.dnsDoh,
      };

  Future<void> _pickDnsMode(
    BuildContext context,
    AppSettingsState state,
  ) async {
    final next = await showGwOptionSheet<DnsMode>(
      context: context,
      title: context.l10n.dns,
      selected: state.dnsMode,
      options: [
        for (final mode in DnsMode.values)
          GwSheetOption(value: mode, label: _dnsLabel(context, mode)),
      ],
    );
    if (next == null || !context.mounted) return;
    context.read<AppSettingsBloc>().add(
          AppSettingsVpnPreferencesUpdated(dnsMode: next),
        );
  }
}
