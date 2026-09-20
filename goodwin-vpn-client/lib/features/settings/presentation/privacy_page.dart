import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/privacy_policy.dart';
import '../../../l10n/l10n_extension.dart';
import '../../../ui/ui.dart';

/// In-app privacy notice plus the public URL for Play / TestFlight.
class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key, this.policyUrl});

  /// HTTPS policy URL. Defaults to [kPrivacyPolicyUrl].
  final String? policyUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.privacy)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          GwCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.privacyWhatTitle, style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                Text(l10n.privacyWhatBody, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GwCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.privacyVpnTitle, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(l10n.privacyVpnBody, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GwCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.privacySecretsTitle, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(l10n.privacySecretsBody, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GwCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.privacyCameraTitle, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(l10n.privacyCameraBody, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GwCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.privacyClipboardTitle, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(l10n.privacyClipboardBody, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GwCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.privacyAppsTitle, style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(l10n.privacyAppsBody, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: () => _openPolicy(context),
            child: Text(l10n.privacyOpenWeb),
          ),
        ],
      ),
    );
  }

  Future<void> _openPolicy(BuildContext context) async {
    final uri = Uri.parse(
      (policyUrl != null && policyUrl!.trim().isNotEmpty)
          ? policyUrl!.trim()
          : kPrivacyPolicyUrl,
    );
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (ok || !context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.privacyOpenFailed)),
    );
  }
}
