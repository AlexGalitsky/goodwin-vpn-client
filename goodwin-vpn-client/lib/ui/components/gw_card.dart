import 'package:flutter/material.dart';

import '../theme/gw_colors.dart';
import '../theme/gw_spacing.dart';

class GwCard extends StatelessWidget {
  const GwCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.onLongPress,
    this.borderColor,
    this.tintColor,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? borderColor;
  final Color? tintColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.gw;
    final body = DecoratedBox(
      decoration: BoxDecoration(
        color: tintColor ?? colors.card,
        borderRadius: BorderRadius.circular(GwRadius.xl),
        border: Border.all(color: borderColor ?? colors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: Theme.of(context).brightness == Brightness.light
                ? 18
                : 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(GwSpacing.lg),
        child: child,
      ),
    );
    if (onTap == null && onLongPress == null) return body;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(GwRadius.xl),
        child: body,
      ),
    );
  }
}
