import 'package:flutter/material.dart';

import '../theme/gw_colors.dart';
import '../theme/gw_spacing.dart';
import '../../l10n/l10n_extension.dart';

class GwConnectButton extends StatelessWidget {
  const GwConnectButton({
    super.key,
    required this.connected,
    required this.busy,
    required this.onPressed,
  });

  final bool connected;
  final bool busy;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.gw;
    final ring = connected ? colors.success : colors.cardBorder;
    final fill = connected ? colors.successMuted : colors.inset;
    final inner = connected ? colors.success : colors.card;
    final iconColor = connected ? colors.successOn : colors.textMuted;

    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: connected ? context.l10n.disconnectVpn : context.l10n.connectVpn,
      child: GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 420),
          width: GwSpacing.connectSize,
          height: GwSpacing.connectSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: fill,
            border: Border.all(color: ring, width: 1.2),
            boxShadow: connected
                ? [
                    BoxShadow(
                      color: colors.success.withValues(alpha: 0.28),
                      blurRadius: 48,
                    ),
                  ]
                : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedRotation(
                duration: const Duration(milliseconds: 700),
                turns: connected ? 1 : 0,
                child: Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: connected
                          ? colors.success.withValues(alpha: 0.28)
                          : colors.cardBorder,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
              Container(
                width: GwSpacing.connectInner,
                height: GwSpacing.connectInner,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: inner,
                ),
                child: busy
                    ? Padding(
                        padding: const EdgeInsets.all(22),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: connected ? colors.successOn : colors.accent,
                        ),
                      )
                    : Icon(
                        Icons.power_settings_new_rounded,
                        size: 32,
                        color: iconColor,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
