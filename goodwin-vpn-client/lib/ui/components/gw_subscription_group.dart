import 'package:flutter/material.dart';

import '../theme/gw_colors.dart';
import '../theme/gw_spacing.dart';
import 'gw_card.dart';

/// Collapsible subscription / manual group card (NPU-style).
class GwSubscriptionGroup extends StatelessWidget {
  const GwSubscriptionGroup({
    super.key,
    required this.title,
    required this.countLabel,
    required this.expanded,
    required this.onToggle,
    required this.children,
    this.subtitle,
    this.trailing,
    this.banner,
  });

  final String title;
  final String countLabel;
  final String? subtitle;
  final bool expanded;
  final VoidCallback onToggle;
  final List<Widget> children;
  final List<Widget>? trailing;
  final Widget? banner;

  @override
  Widget build(BuildContext context) {
    final gw = context.gw;
    final theme = Theme.of(context);

    return GwCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(GwRadius.xl),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
                child: Row(
                  children: [
                    AnimatedRotation(
                      turns: expanded ? 0 : -0.25,
                      duration: const Duration(milliseconds: 180),
                      child: Icon(
                        Icons.expand_more,
                        color: gw.textMuted,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  title,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: gw.inset,
                                  borderRadius: BorderRadius.circular(99),
                                  border: Border.all(color: gw.cardBorder),
                                ),
                                child: Text(
                                  countLabel,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: gw.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (subtitle != null && subtitle!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: gw.textMuted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (trailing != null) ...trailing!,
                  ],
                ),
              ),
            ),
          ),
          if (banner != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: banner!,
            ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: children.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Column(
                      children: [
                        Divider(height: 1, color: gw.cardBorder),
                        const SizedBox(height: 8),
                        ...children,
                      ],
                    ),
                  ),
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
          ),
        ],
      ),
    );
  }
}
