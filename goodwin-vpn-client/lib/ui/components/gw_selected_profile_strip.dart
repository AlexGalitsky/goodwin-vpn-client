import 'package:flutter/material.dart';

import '../theme/gw_colors.dart';
import '../theme/gw_spacing.dart';
import 'gw_card.dart';
import 'gw_protocol_chip.dart';

/// Selected profile row under the Home hero (Change → Profiles).
class GwSelectedProfileStrip extends StatelessWidget {
  const GwSelectedProfileStrip({
    super.key,
    required this.title,
    required this.actionLabel,
    this.subtitle,
    this.protocolKind,
    this.onTap,
    this.onChange,
  });

  final String title;
  final String actionLabel;
  final String? subtitle;
  final String? protocolKind;
  final VoidCallback? onTap;
  final VoidCallback? onChange;

  @override
  Widget build(BuildContext context) {
    final gw = context.gw;
    final theme = Theme.of(context);

    return GwCard(
      padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: gw.accentMuted,
              borderRadius: BorderRadius.circular(GwRadius.lg),
              border: Border.all(color: gw.accent.withValues(alpha: 0.2)),
            ),
            child: Icon(Icons.dns_outlined, color: gw.accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: gw.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (protocolKind != null && protocolKind!.trim().isNotEmpty) ...[
            const SizedBox(width: 4),
            Flexible(
              fit: FlexFit.loose,
              child: GwProtocolChip(protocolKind!),
            ),
          ],
          TextButton(
            onPressed: onChange ?? onTap,
            style: TextButton.styleFrom(
              foregroundColor: gw.accent,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}
