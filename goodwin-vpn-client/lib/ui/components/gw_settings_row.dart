import 'package:flutter/material.dart';

import '../theme/gw_colors.dart';
import '../theme/gw_spacing.dart';
import 'gw_controls.dart';

class GwSettingsRow extends StatelessWidget {
  const GwSettingsRow({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.toggleValue,
    this.onToggle,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool? toggleValue;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.gw;
    return InkWell(
      onTap: onTap ??
          (onToggle != null ? () => onToggle!(!toggleValue!) : null),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: GwSpacing.lg,
          vertical: GwSpacing.md,
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(color: colors.textPrimary),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            if (toggleValue != null)
              GwToggle(value: toggleValue!, onChanged: onToggle)
            else
              ?trailing,
          ],
        ),
      ),
    );
  }
}
