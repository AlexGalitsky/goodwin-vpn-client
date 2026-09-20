import 'package:flutter/material.dart';

import '../theme/gw_colors.dart';
import 'gw_bottom_nav.dart';

/// Side navigation for tablet / desktop (medium + expanded).
class GwSideNav extends StatelessWidget {
  const GwSideNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.extended,
    this.footer,
  });

  final List<GwNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool extended;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final gw = context.gw;
    final width = extended ? 240.0 : 80.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      decoration: BoxDecoration(
        color: gw.navBar,
        border: Border(right: BorderSide(color: gw.cardBorder)),
      ),
      child: SafeArea(
        right: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(extended ? 16 : 12, 16, 12, 8),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: gw.accentMuted,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: gw.accent.withValues(alpha: 0.35)),
                    ),
                    child: Icon(Icons.shield_outlined, color: gw.accent, size: 20),
                  ),
                  if (extended) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'GoodWin VPN',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final item = items[i];
                  final selected = i == currentIndex;
                  final color = selected ? gw.accent : gw.textMuted;
                  final child = Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Material(
                      color: selected ? gw.accentMuted : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () => onTap(i),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: extended ? 12 : 0,
                            vertical: 12,
                          ),
                          child: extended
                              ? Row(
                                  children: [
                                    Icon(
                                      selected ? item.selectedIcon : item.icon,
                                      color: color,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        item.label,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: color,
                                              fontWeight: selected
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                            ),
                                      ),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Icon(
                                    selected ? item.selectedIcon : item.icon,
                                    color: color,
                                    size: 22,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  );
                  if (extended) return child;
                  return Tooltip(message: item.label, child: child);
                },
              ),
            ),
            if (footer != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                child: footer!,
              ),
          ],
        ),
      ),
    );
  }
}
