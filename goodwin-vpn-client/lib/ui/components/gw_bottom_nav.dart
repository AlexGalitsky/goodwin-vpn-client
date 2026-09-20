import 'package:flutter/material.dart';

import '../theme/gw_colors.dart';

class GwNavItem {
  const GwNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

class GwBottomNav extends StatelessWidget {
  const GwBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<GwNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.gw;
    final bottom = MediaQuery.paddingOf(context).bottom;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.navBar,
        border: Border(top: BorderSide(color: colors.cardBorder)),
        boxShadow: Theme.of(context).brightness == Brightness.light
            ? [
                BoxShadow(
                  color: colors.shadow,
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(8, 10, 8, 10 + bottom),
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++)
              Expanded(
                child: _GwNavButton(
                  item: items[i],
                  selected: i == currentIndex,
                  onTap: () => onTap(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GwNavButton extends StatelessWidget {
  const _GwNavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final GwNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.gw;
    final color = selected ? colors.accent : colors.textFaint;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? item.selectedIcon : item.icon,
              size: 22,
              color: color,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    letterSpacing: 0.2,
                    color: color,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: selected ? 20 : 0,
              height: 2,
              decoration: BoxDecoration(
                color: selected ? colors.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(99),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: colors.accent.withValues(alpha: 0.55),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
