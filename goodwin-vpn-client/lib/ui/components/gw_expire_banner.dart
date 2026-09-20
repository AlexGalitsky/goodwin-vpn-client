import 'package:flutter/material.dart';

import '../theme/gw_colors.dart';
import '../theme/gw_spacing.dart';
import 'gw_card.dart';

/// Compact warning for subscription expiry (&lt;3d or expired).
class GwExpireBanner extends StatelessWidget {
  const GwExpireBanner({
    super.key,
    required this.label,
    this.onTap,
  });

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final gw = context.gw;
    final child = GwCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      borderColor: scheme.error.withValues(alpha: 0.45),
      tintColor: scheme.error.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(Icons.event_busy_outlined, size: 18, color: scheme.error),
          const SizedBox(width: GwSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.error,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          if (onTap != null)
            Icon(Icons.chevron_right, size: 18, color: gw.textMuted),
        ],
      ),
    );
    if (onTap == null) return child;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(GwRadius.xl),
        child: child,
      ),
    );
  }
}
