import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goodwin_vpn_core/goodwin_vpn_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../l10n/l10n_extension.dart';
import '../../../l10n/quota_copy.dart';
import '../../../session/import_uri.dart';
import '../../../session/saved_profile.dart';
import '../../../session/subscription.dart';
import '../../../session/subscription_parser.dart';
import '../../../session/vpn_connection_state.dart';
import '../../../ui/ui.dart';
import '../../connection/domain/ping_sample.dart';
import '../../connection/presentation/bloc/connection_selection_cubit.dart';
import '../../routing/domain/vpn_ui_features.dart';
import '../../vpn/presentation/bloc/vpn_connection_bloc.dart';
import '../data/profile_group_collapse_store.dart';
import 'import_flow.dart';
import 'profile_display.dart';
import 'profile_groups.dart';
import 'profile_location.dart';
import 'qr_import_page.dart';
import 'subscription_info_sheet.dart';

/// Catalog of saved share-link profiles (Phase 2).
class ServersPage extends StatefulWidget {
  const ServersPage({super.key});

  @override
  State<ServersPage> createState() => _ServersPageState();
}

class _ServersPageState extends State<ServersPage> {
  final _searchController = TextEditingController();
  final _importController = TextEditingController();
  final _nameController = TextEditingController();
  var _query = '';
  final _refreshingIds = <String>{};
  var _didAutoPing = false;
  var _collapsed = <String>{};
  ProfileGroupCollapseStore? _collapseStore;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoPing();
      _loadCollapse();
    });
  }

  void _loadCollapse() {
    if (!mounted) return;
    try {
      final prefs = context.read<SharedPreferences>();
      _collapseStore = ProfileGroupCollapseStore(prefs);
      setState(() => _collapsed = _collapseStore!.readCollapsed());
    } catch (_) {}
  }

  Future<void> _toggleGroup(String id) async {
    final nextCollapsed = !_collapsed.contains(id);
    setState(() {
      if (nextCollapsed) {
        _collapsed = {..._collapsed, id};
      } else {
        _collapsed = {..._collapsed}..remove(id);
      }
    });
    await _collapseStore?.setCollapsed(id, nextCollapsed);
  }

  void _autoPing() {
    if (!mounted || _didAutoPing) return;
    final profiles = context.read<VpnConnectionBloc>().state.savedProfiles;
    final selection = context.read<ConnectionSelectionCubit>();
    if (profiles.isEmpty || selection.state.pinging) return;
    _didAutoPing = true;
    selection.pingProfiles(profiles);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _importController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selection = context.watch<ConnectionSelectionCubit>().state;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            GwPageHeader(
              eyebrow: context.l10n.profilesEyebrow,
              title: context.l10n.profilesTitle,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GwIconButton(
                    tooltip: selection.pinging
                        ? context.l10n.tooltipPinging
                        : context.l10n.tooltipCheckPing,
                    icon: Icons.network_check,
                    onPressed: selection.pinging
                        ? null
                        : () async {
                            final profiles = context
                                .read<VpnConnectionBloc>()
                                .state
                                .savedProfiles;
                            if (profiles.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(context.l10n.noProfilesToPing),
                                ),
                              );
                              return;
                            }
                            await context
                                .read<ConnectionSelectionCubit>()
                                .pingProfiles(profiles);
                          },
                  ),
                  const SizedBox(width: 8),
                  GwIconButton(
                    tooltip: context.l10n.tooltipImportLink,
                    icon: Icons.add,
                    onPressed: () => _showImportSheet(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<VpnConnectionBloc, VpnConnectionState>(
        builder: (context, vpn) {
          final groups = groupProfiles(
            profiles: vpn.savedProfiles,
            subscriptions: vpn.subscriptions,
            query: _query,
            pingById: selection.pingByProfileId,
          );

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: GwSearchField(
                  controller: _searchController,
                  hintText: context.l10n.searchServersHint,
                  onChanged: (value) => setState(() => _query = value.trim()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: GwCard(
                  padding: EdgeInsets.zero,
                  child: GwSettingsRow(
                    title: context.l10n.smartConnect,
                    subtitle: context.l10n.smartConnectSubtitle,
                    toggleValue: vpn.smartConnect,
                    onToggle: (value) => context
                        .read<VpnConnectionBloc>()
                        .setSmartConnect(value),
                  ),
                ),
              ),
              if (vpn.savedProfiles.isEmpty && vpn.subscriptions.isEmpty)
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        context.l10n.emptyProfiles,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              else if (groups.isEmpty)
                Expanded(
                  child: Center(child: Text(context.l10n.noMatches)),
                )
              else
                Expanded(
                  child: GwContentWidth(
                    maxWidth: GwBreakpoints.contentMaxWide,
                    child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      for (final group in groups) ...[
                        GwSubscriptionGroup(
                          title: _groupTitle(context, group),
                          countLabel: '${group.nodes.length}',
                          subtitle: _groupSubtitle(context, group),
                          expanded: !_collapsed.contains(group.collapseId),
                          onToggle: () => _toggleGroup(group.collapseId),
                          banner: _groupBanner(context, group),
                          trailing: [
                            if (group.subscription != null)
                              IconButton(
                                tooltip: context.l10n.subscriptionAbout,
                                onPressed: () => showSubscriptionInfoSheet(
                                  context: context,
                                  subscription: group.subscription!,
                                ),
                                icon: Icon(
                                  Icons.info_outline,
                                  color: context.gw.textMuted,
                                ),
                              ),
                            if (group.subscription != null)
                              IconButton(
                                tooltip: context.l10n.refreshSubscription,
                                onPressed: _refreshingIds
                                        .contains(group.subscription!.id)
                                    ? null
                                    : () => _refreshSub(
                                          context,
                                          group.subscription!,
                                        ),
                                icon: _refreshingIds
                                        .contains(group.subscription!.id)
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Icon(
                                        Icons.sync,
                                        color: context.gw.textMuted,
                                      ),
                              ),
                            if (group.subscription != null)
                              IconButton(
                                tooltip: context.l10n.removeSubscription,
                                onPressed: () => _deleteSub(
                                  context,
                                  group.subscription!,
                                ),
                                icon: Icon(
                                  Icons.folder_delete_outlined,
                                  color: context.gw.textFaint,
                                ),
                              ),
                          ],
                          children: [
                            for (final profile in group.nodes)
                              _profileRow(
                                context,
                                vpn,
                                selection,
                                profile,
                                fastest: vpn.smartConnect &&
                                    group.subscription != null &&
                                    pickLowestPingProfile(
                                          group.nodes,
                                          selection.pingByProfileId,
                                        )?.id ==
                                        profile.id,
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
                  ),
                ),
            ],
          );
        },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _groupTitle(BuildContext context, ProfileGroup group) {
    final l10n = context.l10n;
    final sub = group.subscription;
    if (sub == null) return l10n.importedManual;
    if (sub.name.trim().isEmpty) {
      return Uri.tryParse(sub.url)?.host ?? l10n.subscriptionFallback;
    }
    return sub.name;
  }

  String? _groupSubtitle(BuildContext context, ProfileGroup group) {
    final l10n = context.l10n;
    final sub = group.subscription;
    final bits = <String>[];
    final account = sub?.accountLabel?.trim();
    if (account != null && account.isNotEmpty) {
      bits.add(account);
    }
    final info = sub?.userinfo == null
        ? ''
        : quotaDisplayLine(l10n, sub!.userinfo!);
    if (info.isNotEmpty) {
      bits.add(info);
      bits.add(l10n.quotaScopeNote);
    }
    if (bits.isEmpty) return null;
    return bits.join(' · ');
  }

  Widget? _groupBanner(BuildContext context, ProfileGroup group) {
    final sub = group.subscription;
    if (sub == null) return null;
    final children = <Widget>[];
    if (sub.revoked) {
      children.add(
        Text(
          context.l10n.revokedKeepNodes,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
        ),
      );
    }
    final warn = expireWarningLabel(context.l10n, sub.userinfo);
    if (warn != null) {
      if (children.isNotEmpty) children.add(const SizedBox(height: 8));
      children.add(
        GwExpireBanner(
          label: warn,
          onTap: () => showSubscriptionInfoSheet(
            context: context,
            subscription: sub,
          ),
        ),
      );
    }
    if (children.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget _profileRow(
    BuildContext context,
    VpnConnectionState vpn,
    ConnectionSelectionState selection,
    SavedProfile profile, {
    bool fastest = false,
  }) {
    final selected = selection.selectedProfileId == profile.id;
    final sample = selection.pingByProfileId[profile.id];
    final pingingThis = selection.pingingIds.contains(profile.id);
    final kind = protocolKindForLink(profile.link);
    final busy = vpn.phase == ConnectionPhase.connecting ||
        vpn.phase == ConnectionPhase.disconnecting;
    final gw = context.gw;
    final pingColor = () {
      if (sample == null || !sample.isOk) return gw.textFaint;
      final ms = sample.milliseconds!;
      if (ms < 100) return gw.success;
      if (ms < 300) return gw.warning;
      return gw.textMuted;
    }();
    final displayName = profileDisplayName(profile);
    final location = profileLocationHint(displayName);
    final subtitle = [
      if (location != null && location != displayName) location,
      if (pingingThis) context.l10n.pinging,
      if (!pingingThis && sample != null) pingLabel(sample),
      if (fastest) context.l10n.fastest,
    ].join(' · ');

    return GwProfileRow(
      title: displayName,
      selected: selected,
      busy: busy,
      protocolKind: kind,
      subtitle: subtitle.isEmpty ? null : subtitle,
      subtitleColor: pingColor,
      onTap: () => _selectProfile(context, profile),
      onLongPress: () => _editProfile(context, profile),
      deleteTooltip: context.l10n.delete,
      onDelete: () async {
        final ok = await _confirm(
          context,
          title: context.l10n.delete,
          body: context.l10n.deleteProfileConfirm,
        );
        if (ok != true || !context.mounted) return;
        await context.read<VpnConnectionBloc>().removeSavedProfile(
              profile.id,
            );
        if (!context.mounted) return;
        final sel = context.read<ConnectionSelectionCubit>();
        if (sel.state.selectedProfileId == profile.id) {
          sel.clearSelection();
        }
      },
    );
  }

  Future<void> _refreshSub(
    BuildContext context,
    VpnSubscription subscription,
  ) async {
    setState(() => _refreshingIds.add(subscription.id));
    try {
      await context.read<VpnConnectionBloc>().refreshSubscription(
            subscription.id,
          );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.updatedSubscription(subscription.name))),
      );
    } on SubscriptionRevokedException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    } finally {
      if (mounted) {
        setState(() => _refreshingIds.remove(subscription.id));
      }
    }
  }

  Future<void> _deleteSub(
    BuildContext context,
    VpnSubscription subscription,
  ) async {
    final ok = await _confirm(
      context,
      title: context.l10n.removeSubscription,
      body: context.l10n.deleteSubscriptionConfirm,
    );
    if (ok != true || !context.mounted) return;
    await context.read<VpnConnectionBloc>().removeSubscription(subscription.id);
  }

  Future<void> _selectProfile(
    BuildContext context,
    SavedProfile profile,
  ) async {
    context.read<ConnectionSelectionCubit>().selectProfile(profile.id);
    final phase = context.read<VpnConnectionBloc>().state.phase;
    // Connected header uses the live session link. Persist "next connect" only
    // when the tunnel is down — otherwise Home would lie about the node.
    if (phase == ConnectionPhase.connected ||
        phase == ConnectionPhase.connecting ||
        phase == ConnectionPhase.disconnecting) {
      return;
    }
    await context.read<VpnConnectionBloc>().selectShareLink(profile.link);
  }

  Future<bool?> _confirm(
    BuildContext context, {
    required String title,
    required String body,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(ctx.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(ctx.l10n.delete),
          ),
        ],
      ),
    );
  }

  Future<void> _showImportSheet(BuildContext context) async {
    _importController.clear();
    _nameController.clear();
    if (!context.mounted) return;
    final savedFuture = showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.viewInsetsOf(ctx).bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                ctx.l10n.importProfile,
                style: Theme.of(ctx).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _nameController,
                onTapOutside: gwUnfocusOnTapOutside,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: ctx.l10n.nameOptional,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _importController,
                minLines: 2,
                maxLines: 4,
                onTapOutside: gwUnfocusOnTapOutside,
                decoration: InputDecoration(
                  labelText: ctx.l10n.importLinkLabel,
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ctx.l10n.importLinkHint,
                style: Theme.of(ctx).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () async {
                          final text = await _clipboardText();
                          if (text == null) return;
                          _importController.text = text;
                        },
                        child: Text(ctx.l10n.paste),
                      ),
                      if (VpnUiFeatures.resolve(
                        isAndroid: Platform.isAndroid,
                        isIos: Platform.isIOS,
                        tunnelSupported: false,
                      ).qrCamera)
                        TextButton(
                          onPressed: () async {
                            final scanned = await QrImportPage.open(ctx);
                            if (scanned == null || scanned.trim().isEmpty) {
                              return;
                            }
                            _importController.text = scanned.trim();
                          },
                          child: Text(ctx.l10n.scanQr),
                        ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: Text(ctx.l10n.cancel),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: Text(ctx.l10n.import),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    unawaited(_clipboardText().then((clip) {
      if (clip != null && mounted) {
        _importController.text = clip;
      }
    }));
    final saved = await savedFuture;

    if (saved != true || !context.mounted) return;
    final link = _importController.text.trim();
    if (link.isEmpty) return;

    final name = _nameController.text.trim();
    try {
      final message = await applyImportedText(
        vpn: context.read<VpnConnectionBloc>(),
        selection: context.read<ConnectionSelectionCubit>(),
        l10n: context.l10n,
        raw: link,
        name: name.isEmpty ? null : name,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } on ImportUriException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } on ShareLinkParseException catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.unrecognizedShareLink)),
      );
      return;
    } on SubscriptionParseException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
      return;
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  Future<void> _editProfile(
    BuildContext context,
    SavedProfile profile,
  ) async {
    final nameCtrl = TextEditingController(text: profile.name);
    final linkCtrl = TextEditingController(text: profile.link);
    final result = await showDialog<({String name, String link})>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.editProfile),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              onTapOutside: gwUnfocusOnTapOutside,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: ctx.l10n.name),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: linkCtrl,
              minLines: 2,
              maxLines: 4,
              onTapOutside: gwUnfocusOnTapOutside,
              decoration: InputDecoration(labelText: ctx.l10n.shareLink),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(ctx.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop((
              name: nameCtrl.text.trim(),
              link: linkCtrl.text.trim(),
            )),
            child: Text(ctx.l10n.apply),
          ),
        ],
      ),
    );
    nameCtrl.dispose();
    linkCtrl.dispose();
    if (result == null || !context.mounted) return;
    if (result.link.isEmpty) return;
    await context.read<VpnConnectionBloc>().updateSavedProfile(
          id: profile.id,
          name: result.name,
          link: result.link,
        );
  }
}

Future<String?> _clipboardText() async {
  try {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();
    if (text == null || text.isEmpty) return null;
    return text;
  } catch (_) {
    return null;
  }
}
