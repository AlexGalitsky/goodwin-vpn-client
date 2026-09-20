import 'package:flutter/material.dart';

import '../theme/gw_colors.dart';
import '../theme/gw_spacing.dart';

/// Short protocol mark (`vless` / `hy2` / `tt`). Not a Reality / DPI lecture.
class GwProtocolChip extends StatelessWidget {
  const GwProtocolChip(this.kind, {super.key});

  final String kind;

  @override
  Widget build(BuildContext context) {
    final colors = context.gw;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colors.inset,
        borderRadius: BorderRadius.circular(GwRadius.full),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Text(
        kind,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
