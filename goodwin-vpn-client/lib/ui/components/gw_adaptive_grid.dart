import 'package:flutter/material.dart';

import '../layout/gw_breakpoints.dart';

/// One column on phone/tablet; two columns of section cards on desktop width.
class GwAdaptiveGrid extends StatelessWidget {
  const GwAdaptiveGrid({
    super.key,
    required this.children,
    this.spacing = 12,
  });

  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final expanded =
        GwBreakpoints.of(context) == GwWindowSize.expanded;
    if (!expanded || children.length < 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: spacing),
            children[i],
          ],
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final colW = (constraints.maxWidth - spacing) / 2;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children)
              SizedBox(width: colW, child: child),
          ],
        );
      },
    );
  }
}
