import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/locale_preference.dart';
import '../../../core/config/theme_preference.dart';
import '../../../core/config/ui_mode.dart';
import '../../../l10n/l10n_extension.dart';
import '../../../session/vpn_connection_state.dart';
import '../../../ui/ui.dart';
import '../../routing/domain/vpn_backend_capability.dart';
import '../../routing/domain/vpn_ui_features.dart';
import '../../split/data/android_split_client.dart';
import '../../vpn/presentation/bloc/vpn_connection_bloc.dart';
import 'bloc/app_settings_bloc.dart';
import 'kill_switch_ux.dart';
import 'settings_about_page.dart';
import 'settings_backup_page.dart';
import 'settings_network_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: BlocBuilder<AppSettingsBloc, AppSettingsState>(
          builder: (context, state) {
            final advanced = state.uiMode == UiMode.advanced;
            final vpnBloc = context.watch<VpnConnectionBloc>();
            final features = VpnUiFeatures.resolve(
              isAndroid: Platform.isAndroid,
              isIos: Platform.isIOS,
              tunnelSupported: vpnBloc.tunnelSupported,
              backend: vpnBackendKindForLink(vpnBloc.state.activeShareLink),
            );
            return ListView(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
              children: [
                GwPageHeader(
                  eyebrow: context.l10n.settingsEyebrow,
                  title: context.l10n.settingsTitle,
                ),
                GwContentWidth(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GwAdaptiveGrid(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GwSectionLabel(context.l10n.appearance),
                            GwCard(
                              padding: EdgeInsets.zero,
                              child: Column(
                                children: [
                                  GwSettingsRow(
                                    title: context.l10n.colorTheme,
                                    subtitle: _themeLabel(
                                      context,
                                      state.themePreference,
                                    ),
                                    trailing: Icon(
                                      Icons.chevron_right,
                                      color: context.gw.textMuted,
                                    ),
                                    onTap: () => _pickTheme(context, state),
                                  ),
                                  Divider(
                                    color: context.gw.cardBorder,
                                    height: 1,
                                  ),
                                  GwSettingsRow(
                                    title: context.l10n.language,
                                    subtitle: _localeLabel(
                                      context,
                                      state.localePreference,
                                    ),
                                    trailing: Icon(
                                      Icons.chevron_right,
                                      color: context.gw.textMuted,
                                    ),
                                    onTap: () => _pickLocale(context, state),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GwSectionLabel(context.l10n.general),
                            GwCard(
                              padding: EdgeInsets.zero,
                              child: GwSettingsRow(
                                title: context.l10n.advancedMode,
                                subtitle: context.l10n.advancedModeSubtitle,
                                toggleValue: advanced,
                                onToggle: (value) {
                                  context.read<AppSettingsBloc>().add(
                                        AppSettingsUiModeUpdated(
                                          value
                                              ? UiMode.advanced
                                              : UiMode.standard,
                                        ),
                                      );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            GwCard(
                              padding: EdgeInsets.zero,
                              child: BlocBuilder<VpnConnectionBloc,
                                  VpnConnectionState>(
                                buildWhen: (prev, next) =>
                                    prev.autoConnect != next.autoConnect ||
                                    prev.phase != next.phase,
                                builder: (context, vpn) {
                                  final busy = vpn.phase ==
                                          ConnectionPhase.connecting ||
                                      vpn.phase ==
                                          ConnectionPhase.disconnecting;
                                  return GwSettingsRow(
                                    title: context.l10n.reconnectOnLaunch,
                                    subtitle: context
                                        .l10n.reconnectOnLaunchSubtitle,
                                    toggleValue: vpn.autoConnect,
                                    onToggle: busy
                                        ? null
                                        : (value) => context
                                            .read<VpnConnectionBloc>()
                                            .setAutoConnect(value),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (advanced)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: GwCard(
                      padding: EdgeInsets.zero,
                      child: GwSettingsRow(
                        title: context.l10n.dns,
                        subtitle: context.l10n.advancedModeSubtitle,
                        trailing: Icon(
                          Icons.chevron_right,
                          color: context.gw.textMuted,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const SettingsNetworkPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                if (features.killSwitch)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: GwCard(
                      padding: EdgeInsets.zero,
                      child: GwSettingsRow(
                        title: context.l10n.killSwitch,
                        subtitle: killSwitchSettingsSubtitle(
                          context.l10n,
                          isIos: Platform.isIOS,
                        ),
                        toggleValue: state.killSwitch,
                        onToggle: (value) =>
                            _onKillSwitchChanged(context, value),
                      ),
                    ),
                  ),
                GwContentWidth(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GwAdaptiveGrid(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GwSectionLabel(context.l10n.backup),
                            GwCard(
                              padding: EdgeInsets.zero,
                              child: GwSettingsRow(
                                title: context.l10n.backup,
                                subtitle: context.l10n.backupHubSubtitle,
                                trailing: Icon(
                                  Icons.chevron_right,
                                  color: context.gw.textMuted,
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          const SettingsBackupPage(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GwSectionLabel(context.l10n.about),
                            GwCard(
                              padding: EdgeInsets.zero,
                              child: GwSettingsRow(
                                title: context.l10n.about,
                                subtitle: context.l10n.aboutHubSubtitle,
                                trailing: Icon(
                                  Icons.chevron_right,
                                  color: context.gw.textMuted,
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          const SettingsAboutPage(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

String _themeLabel(BuildContext context, ThemePreference pref) =>
    switch (pref) {
      ThemePreference.system => context.l10n.themeSystem,
      ThemePreference.light => context.l10n.themeLight,
      ThemePreference.dark => context.l10n.themeDark,
    };

String _localeLabel(BuildContext context, LocalePreference pref) =>
    pref == LocalePreference.system
        ? context.l10n.localeSystem
        : pref.nativeLabel;

Future<void> _pickTheme(BuildContext context, AppSettingsState state) async {
  final next = await showGwOptionSheet<ThemePreference>(
    context: context,
    title: context.l10n.colorTheme,
    subtitle: context.l10n.colorThemeSubtitle,
    selected: state.themePreference,
    options: [
      for (final pref in ThemePreference.values)
        GwSheetOption(value: pref, label: _themeLabel(context, pref)),
    ],
  );
  if (next == null || !context.mounted) return;
  context.read<AppSettingsBloc>().add(
        AppSettingsThemePreferenceUpdated(next),
      );
}

Future<void> _pickLocale(BuildContext context, AppSettingsState state) async {
  final next = await showGwOptionSheet<LocalePreference>(
    context: context,
    title: context.l10n.language,
    subtitle: context.l10n.languageSubtitle,
    selected: state.localePreference,
    options: [
      for (final pref in LocalePreference.values)
        GwSheetOption(value: pref, label: _localeLabel(context, pref)),
    ],
  );
  if (next == null || !context.mounted) return;
  context.read<AppSettingsBloc>().add(
        AppSettingsLocalePreferenceUpdated(next),
      );
}

Future<void> _onKillSwitchChanged(BuildContext context, bool value) async {
  if (Platform.isAndroid) {
    if (value) {
      final open = await showModalBottomSheet<bool>(
        context: context,
        builder: (ctx) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                ctx.l10n.killSwitchAndroidEnableTitle,
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Text(ctx.l10n.killSwitchAndroidEnableBody),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(ctx.l10n.killSwitchOpenSettings),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(ctx.l10n.cancel),
              ),
            ],
          ),
        ),
      );
      if (open != true || !context.mounted) return;
      final returned = await waitUntilAppReturned(
        leave: () => _openAndroidVpnSettings(context),
      );
      if (!context.mounted) return;
      if (!returned) return;
      final confirmed = await showModalBottomSheet<bool>(
        context: context,
        builder: (ctx) => Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                ctx.l10n.killSwitchAndroidConfirmTitle,
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Text(ctx.l10n.killSwitchAndroidConfirmBody),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(ctx.l10n.killSwitchAndroidConfirmYes),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(ctx.l10n.killSwitchAndroidConfirmNo),
              ),
            ],
          ),
        ),
      );
      if (androidKillSwitchShouldTurnOn(
            returnedFromSettings: returned,
            confirmedAlwaysOn: confirmed,
          ) &&
          context.mounted) {
        context.read<AppSettingsBloc>().add(
              const AppSettingsVpnPreferencesUpdated(killSwitch: true),
            );
      }
      return;
    }

    context.read<AppSettingsBloc>().add(
          const AppSettingsVpnPreferencesUpdated(killSwitch: false),
        );
    final open = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.killSwitchAndroidDisableTitle),
        content: Text(ctx.l10n.killSwitchAndroidDisableBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(ctx.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(ctx.l10n.killSwitchOpenSettings),
          ),
        ],
      ),
    );
    if (open == true && context.mounted) {
      await _openAndroidVpnSettings(context);
    }
    return;
  }

  context.read<AppSettingsBloc>().add(
        AppSettingsVpnPreferencesUpdated(killSwitch: value),
      );
}

Future<void> _openAndroidVpnSettings(BuildContext context) async {
  try {
    await AndroidSplitClient().openVpnSettings();
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$e')),
    );
  }
}
