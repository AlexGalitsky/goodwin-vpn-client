import 'package:flutter/material.dart';

import '../theme/gw_colors.dart';
import 'gw_card.dart';
import 'gw_protocol_chip.dart';

/// Single profile row inside a subscription group.
class GwProfileRow extends StatelessWidget {
  const GwProfileRow({
    super.key,
    required this.title,
    required this.selected,
    required this.busy,
    this.protocolKind,
    this.subtitle,
    this.subtitleColor,
    this.onTap,
    this.onLongPress,
    this.onDelete,
    this.deleteTooltip,
  });

  final String title;
  final bool selected;
  final bool busy;
  final String? protocolKind;
  final String? subtitle;
  final Color? subtitleColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDelete;
  final String? deleteTooltip;

  @override
  Widget build(BuildContext context) {
    final gw = context.gw;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GwCard(
        padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
        onTap: busy ? null : onTap,
        onLongPress: busy ? null : onLongPress,
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: selected ? gw.accent : (subtitleColor ?? gw.textFaint),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      if (protocolKind != null) ...[
                        const SizedBox(width: 8),
                        GwProtocolChip(protocolKind!),
                      ],
                    ],
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: subtitleColor ?? gw.textMuted,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            if (!busy && onDelete != null)
              IconButton(
                tooltip: deleteTooltip,
                icon: Icon(Icons.delete_outline, color: gw.textFaint),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}
