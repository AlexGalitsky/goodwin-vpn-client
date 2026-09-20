import 'package:flutter/widgets.dart';

import 'gw_breakpoints.dart';

/// Centers [child] and caps width for readable Home/Settings columns.
class GwContentWidth extends StatelessWidget {
  const GwContentWidth({
    super.key,
    required this.child,
    this.maxWidth = GwBreakpoints.contentMax,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
