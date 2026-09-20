import 'package:flutter/material.dart';

/// Marker for power-user / potentially dangerous settings.
class AdvancedDangerBadge extends StatelessWidget {
  const AdvancedDangerBadge({super.key, this.tooltip});

  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      Icons.warning_amber_rounded,
      size: 18,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45),
    );
    final child = Padding(
      padding: const EdgeInsets.only(right: 8),
      child: icon,
    );
    if (tooltip == null || tooltip!.isEmpty) return child;
    return Tooltip(message: tooltip!, child: child);
  }
}
