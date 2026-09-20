import 'package:flutter/material.dart';

import '../theme/gw_colors.dart';
import '../theme/gw_spacing.dart';
import '../../l10n/l10n_extension.dart';
import 'gw_protocol_chip.dart';

class GwPageHeader extends StatelessWidget {
  const GwPageHeader({
    super.key,
    this.eyebrow,
    required this.title,
    this.description,
    this.trailing,
  });

  final String? eyebrow;
  final String title;
  final String? description;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final gw = context.gw;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        GwSpacing.screen,
        GwSpacing.md,
        GwSpacing.screen,
        GwSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (eyebrow != null)
                  Text(
                    eyebrow!.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          letterSpacing: 1.4,
                          color: gw.accent,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                if (description != null && description!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    description!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: gw.textSecondary,
                        ),
                  ),
                ],
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class GwHomeHeader extends StatelessWidget {
  const GwHomeHeader({
    super.key,
    required this.profileLabel,
    this.protocolKind,
    this.onProfileTap,
  });

  final String profileLabel;
  final String? protocolKind;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.gw;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        GwSpacing.screen,
        GwSpacing.md,
        GwSpacing.screen,
        GwSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.accentMuted,
              borderRadius: BorderRadius.circular(GwRadius.lg),
              border: Border.all(color: colors.accent.withValues(alpha: 0.2)),
            ),
            child: Icon(Icons.bolt_rounded, color: colors.accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: onProfileTap,
              borderRadius: BorderRadius.circular(GwRadius.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.activeProfile,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          profileLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      if (protocolKind != null &&
                          protocolKind!.trim().isNotEmpty) ...[
                        const SizedBox(width: 8),
                        GwProtocolChip(protocolKind!),
                      ],
                      if (onProfileTap != null)
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: colors.textMuted,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
