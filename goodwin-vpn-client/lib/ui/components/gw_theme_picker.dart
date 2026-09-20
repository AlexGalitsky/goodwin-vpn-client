import 'package:flutter/material.dart';

import '../../core/config/theme_preference.dart';
import '../../l10n/l10n_extension.dart';
import '../theme/gw_colors.dart';
import '../theme/gw_spacing.dart';

class GwThemePicker extends StatelessWidget {
  const GwThemePicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final ThemePreference value;
  final ValueChanged<ThemePreference> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final option in ThemePreference.values) ...[
          if (option != ThemePreference.values.first) const SizedBox(width: 8),
          Expanded(
            child: _ThemeTile(
              preference: option,
              selected: value == option,
              onTap: () => onChanged(option),
            ),
          ),
        ],
      ],
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({
    required this.preference,
    required this.selected,
    required this.onTap,
  });

  final ThemePreference preference;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.gw;
    final (icon, label) = switch (preference) {
      ThemePreference.light => (Icons.light_mode_outlined, context.l10n.themeLight),
      ThemePreference.dark => (Icons.dark_mode_outlined, context.l10n.themeDark),
      ThemePreference.system => (
          Icons.brightness_auto_outlined,
          context.l10n.themeSystem,
        ),
    };

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(GwRadius.lg),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
          decoration: BoxDecoration(
            color: selected ? colors.accentMuted : colors.inset,
            borderRadius: BorderRadius.circular(GwRadius.lg),
            border: Border.all(
              color: selected ? colors.accent : colors.cardBorder,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Column(
            children: [
              _ThemeSwatch(preference: preference),
              const SizedBox(height: 8),
              Icon(
                icon,
                size: 18,
                color: selected ? colors.accent : colors.textMuted,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: selected ? colors.accent : colors.textSecondary,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeSwatch extends StatelessWidget {
  const _ThemeSwatch({required this.preference});

  final ThemePreference preference;

  @override
  Widget build(BuildContext context) {
    final light = GwColors.light;
    final dark = GwColors.dark;
    if (preference == ThemePreference.system) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 28,
          child: Row(
            children: [
              Expanded(child: ColoredBox(color: light.canvas)),
              Expanded(child: ColoredBox(color: dark.canvas)),
            ],
          ),
        ),
      );
    }
    final palette =
        preference == ThemePreference.light ? light : dark;
    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: palette.canvas,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.cardBorder),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 6),
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: palette.accent,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
