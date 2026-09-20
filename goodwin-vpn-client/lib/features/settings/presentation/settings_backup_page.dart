import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/ui_mode.dart';
import '../../../l10n/l10n_extension.dart';
import '../../../session/backup_codec.dart';
import '../../../session/backup_files.dart';
import '../../../ui/ui.dart';
import '../../vpn/presentation/bloc/vpn_connection_bloc.dart';
import 'bloc/app_settings_bloc.dart';

/// Export / import backup — pushed from Settings hub.
class SettingsBackupPage extends StatelessWidget {
  const SettingsBackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final advanced =
        context.watch<AppSettingsBloc>().state.uiMode == UiMode.advanced;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(context.l10n.backup),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          GwCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                GwSettingsRow(
                  title: context.l10n.exportBackup,
                  subtitle: context.l10n.exportBackupSubtitle,
                  trailing: Icon(
                    Icons.save_alt,
                    color: context.gw.textMuted,
                  ),
                  onTap: () => _exportBackupFile(context),
                ),
                Divider(color: context.gw.cardBorder, height: 1),
                GwSettingsRow(
                  title: context.l10n.importBackup,
                  subtitle: context.l10n.importBackupSubtitle,
                  trailing: Icon(
                    Icons.file_open_outlined,
                    color: context.gw.textMuted,
                  ),
                  onTap: () => _importBackupFile(context),
                ),
                if (advanced) ...[
                  Divider(color: context.gw.cardBorder, height: 1),
                  GwSettingsRow(
                    title: context.l10n.copyJsonClipboard,
                    subtitle: context.l10n.copyJsonClipboardSubtitle,
                    trailing: Icon(
                      Icons.copy_all_outlined,
                      color: context.gw.textMuted,
                    ),
                    onTap: () => _copyBackupClipboard(context),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _copyBackupClipboard(BuildContext context) async {
  final encoded = encodeBackup(_backupFromState(context));
  await Clipboard.setData(ClipboardData(text: encoded));
  if (!context.mounted) return;
  final count =
      context.read<VpnConnectionBloc>().state.savedProfiles.length;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        count == 0
            ? context.l10n.copiedEmptyProfiles
            : context.l10n.copiedProfilesJson(count),
      ),
    ),
  );
}

Future<void> _exportBackupFile(BuildContext context) async {
  final password = await _askBackupPassword(
    context,
    title: context.l10n.exportBackupTitle,
    subtitle: context.l10n.exportBackupPasswordHint,
    confirm: true,
  );
  if (password == null || !context.mounted) return;
  try {
    final saved = await const BackupFileIO().save(
      fileName: 'goodwin-vpn-backup.json',
      contents: encodeBackup(
        _backupFromState(context),
        password: password.isEmpty ? null : password,
      ),
    );
    if (!context.mounted || !saved) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          password.isEmpty
              ? context.l10n.backupFileSaved
              : context.l10n.encryptedBackupSaved,
        ),
      ),
    );
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$e')),
    );
  }
}

Future<void> _importBackupFile(BuildContext context) async {
  String? raw;
  try {
    raw = await const BackupFileIO().pick();
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$e')),
    );
    return;
  }
  if (raw == null || !context.mounted) return;
  await _restoreBackupRaw(context, raw);
}

Future<void> _restoreBackupRaw(BuildContext context, String raw) async {
  String? password;
  try {
    decodeBackup(raw);
  } on BackupPasswordException {
    password = await _askBackupPassword(
      context,
      title: context.l10n.encryptedBackupTitle,
      subtitle: context.l10n.encryptedBackupHint,
    );
    if (password == null || !context.mounted) return;
  } on BackupException catch (e) {
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
    return;
  }

  try {
    final backup = decodeBackup(raw, password: password);
    final result =
        await context.read<VpnConnectionBloc>().restoreBackup(backup);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.l10n.importedBackupCounts(
            result.addedProfiles,
            result.addedSubscriptions,
          ),
        ),
      ),
    );
  } on BackupException catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message)),
    );
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$e')),
    );
  }
}

ProfileBackup _backupFromState(BuildContext context) {
  final vpn = context.read<VpnConnectionBloc>().state;
  return ProfileBackup(
    profiles: vpn.savedProfiles,
    subscriptions: vpn.subscriptions,
  );
}

Future<String?> _askBackupPassword(
  BuildContext context, {
  required String title,
  required String subtitle,
  bool confirm = false,
}) async {
  final password = TextEditingController();
  final repeat = TextEditingController();
  try {
    return await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(subtitle),
              const SizedBox(height: 12),
              TextField(
                controller: password,
                obscureText: true,
                autofocus: true,
                onTapOutside: gwUnfocusOnTapOutside,
                textInputAction:
                    confirm ? TextInputAction.next : TextInputAction.done,
                decoration: InputDecoration(
                  labelText: confirm
                      ? ctx.l10n.passwordOptional
                      : ctx.l10n.password,
                ),
              ),
              if (confirm) ...[
                const SizedBox(height: 8),
                TextField(
                  controller: repeat,
                  obscureText: true,
                  onTapOutside: gwUnfocusOnTapOutside,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: ctx.l10n.confirmPassword,
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(ctx.l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                final first = password.text;
                if (confirm && first.isNotEmpty && first != repeat.text) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text(ctx.l10n.passwordsDoNotMatch)),
                  );
                  return;
                }
                Navigator.of(ctx).pop(first);
              },
              child: Text(ctx.l10n.continueAction),
            ),
          ],
        );
      },
    );
  } finally {
    password.dispose();
    repeat.dispose();
  }
}
