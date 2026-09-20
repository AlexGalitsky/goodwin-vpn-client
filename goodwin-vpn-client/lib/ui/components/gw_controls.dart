import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../theme/gw_colors.dart';
import '../theme/gw_spacing.dart';

/// iOS/macOS skip unfocus in the framework default [TextField.onTapOutside].
void gwDismissKeyboard() {
  FocusManager.instance.primaryFocus?.unfocus();
}

void gwUnfocusOnTapOutside(PointerDownEvent _) => gwDismissKeyboard();

class GwToggle extends StatelessWidget {
  const GwToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.gw;
    final enabled = onChanged != null;
    return Semantics(
      toggled: value,
      button: true,
      child: GestureDetector(
        onTap: enabled ? () => onChanged!(!value) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: GwSizes.toggleWidth,
          height: GwSizes.toggleHeight,
          padding: const EdgeInsets.all(4),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(
            color: value ? colors.accent : colors.inset,
            borderRadius: BorderRadius.circular(GwRadius.full),
          ),
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class GwSectionLabel extends StatelessWidget {
  const GwSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        GwSpacing.sm,
        GwSpacing.lg,
        GwSpacing.sm,
        GwSpacing.sm,
      ),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}

class GwStatusPill extends StatelessWidget {
  const GwStatusPill({
    super.key,
    required this.label,
    required this.active,
  });

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colors = context.gw;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: active ? colors.successMuted : colors.trackOff,
        borderRadius: BorderRadius.circular(GwRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: active ? colors.success : colors.textFaint,
              shape: BoxShape.circle,
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: colors.success.withValues(alpha: 0.55),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.2,
                  color: active ? colors.success : colors.textMuted,
                ),
          ),
        ],
      ),
    );
  }
}

class GwIconButton extends StatelessWidget {
  const GwIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = context.gw;
    final button = Material(
      color: colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GwRadius.md),
        side: BorderSide(color: colors.cardBorder),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(GwRadius.md),
        child: SizedBox(
          width: GwSizes.touchTarget,
          height: GwSizes.touchTarget,
          child: Icon(icon, size: GwSizes.iconMd, color: colors.textSecondary),
        ),
      ),
    );
    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}

class GwSearchField extends StatelessWidget {
  const GwSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.gw;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onTapOutside: gwUnfocusOnTapOutside,
      textInputAction: TextInputAction.search,
      style: Theme.of(context)
          .textTheme
          .titleSmall
          ?.copyWith(color: colors.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(Icons.search, color: colors.textMuted, size: 18),
        isDense: true,
      ),
    );
  }
}

class GwModeSwitch extends StatelessWidget {
  const GwModeSwitch({
    super.key,
    required this.advanced,
    required this.onChanged,
  });

  final bool advanced;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.gw;
    Widget chip(String label, bool selected, VoidCallback onTap) {
      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected
                ? (advanced && label == 'Advanced'
                    ? colors.accentMuted
                    : colors.trackOff)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(GwRadius.full),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontSize: 11,
                  color: selected
                      ? (label == 'Advanced' ? colors.accent : colors.textPrimary)
                      : colors.textMuted,
                ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(GwRadius.full),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          chip('Standard', !advanced, () => onChanged(false)),
          chip('Advanced', advanced, () => onChanged(true)),
        ],
      ),
    );
  }
}
