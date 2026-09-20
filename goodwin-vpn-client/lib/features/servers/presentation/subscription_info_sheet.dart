import 'package:flutter/material.dart';

import '../../../l10n/l10n_extension.dart';
import '../../../l10n/quota_copy.dart';
import '../../../session/subscription.dart';
import '../../../ui/ui.dart';

Future<void> showSubscriptionInfoSheet({
  required BuildContext context,
  required VpnSubscription subscription,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (ctx) => _SubscriptionInfoSheet(subscription: subscription),
  );
}

class _SubscriptionInfoSheet extends StatelessWidget {
  const _SubscriptionInfoSheet({required this.subscription});

  final VpnSubscription subscription;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final info = subscription.userinfo;
    final account = subscription.accountLabel?.trim();
    final last = subscription.lastFetched;
    final expire = info?.expire;
    final rows = <_InfoRow>[
      _InfoRow(
        label: l10n.subscriptionHost,
        value: subscriptionHostDisplay(subscription.url),
      ),
      if (account != null && account.isNotEmpty)
        _InfoRow(label: l10n.subscriptionAccount, value: account),
      _InfoRow(
        label: l10n.subscriptionLastFetched,
        value: last == null
            ? l10n.subscriptionNeverFetched
            : _formatStamp(last.toLocal()),
      ),
    ];
    final intervalHours =
        subscription.intervalHours <= 0 ? 24 : subscription.intervalHours;

    final quotaLine = info == null ? '' : quotaDisplayLine(l10n, info);
    final deviceLine = info == null ? null : deviceDisplayLine(l10n, info);
    final expireLabel = expire == null
        ? null
        : _formatStamp(expire.toLocal());

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              subscription.name.trim().isEmpty
                  ? l10n.subscriptionAbout
                  : subscription.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.subscriptionAbout,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.gw.textMuted,
                  ),
            ),
            const SizedBox(height: 16),
            GwCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (var i = 0; i < rows.length; i++) ...[
                    if (i > 0)
                      Divider(height: 1, color: context.gw.cardBorder),
                    _sheetRow(
                      context,
                      rows[i].label,
                      rows[i].value.isEmpty ? null : rows[i].value,
                    ),
                  ],
                  Divider(height: 1, color: context.gw.cardBorder),
                  _sheetRow(
                    context,
                    l10n.subscriptionUpdateInterval(intervalHours),
                    null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            GwCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _sheetRow(
                    context,
                    l10n.subscriptionQuota,
                    quotaLine.isEmpty ? l10n.subscriptionNoUserinfo : quotaLine,
                  ),
                  if (expireLabel != null) ...[
                    Divider(height: 1, color: context.gw.cardBorder),
                    _sheetRow(
                      context,
                      l10n.subscriptionExpires,
                      expireLabel,
                    ),
                  ],
                  if (deviceLine != null) ...[
                    Divider(height: 1, color: context.gw.cardBorder),
                    _sheetRow(
                      context,
                      l10n.subscriptionDevices,
                      deviceLine,
                    ),
                  ],
                  if (info != null && (info.hasQuota || info.used > 0)) ...[
                    Divider(height: 1, color: context.gw.cardBorder),
                    _sheetRow(context, l10n.quotaScopeNote, null),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetRow(BuildContext context, String title, String? subtitle) {
    return GwSettingsRow(
      title: title,
      subtitle: subtitle,
    );
  }

  String _formatStamp(DateTime local) {
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $hh:$mm';
  }
}

class _InfoRow {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;
}
