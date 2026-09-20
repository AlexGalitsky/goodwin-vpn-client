import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/gw_colors.dart';

class GwCanvas extends StatelessWidget {
  const GwCanvas({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.gw;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final overlay =
        (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
            .copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: colors.navBar,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlay,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.canvas,
          gradient: RadialGradient(
            center: const Alignment(0, -1.15),
            radius: 1.15,
            colors: [colors.canvasGlow, colors.canvas],
          ),
        ),
        child: child,
      ),
    );
  }
}
