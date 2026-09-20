/// Width breakpoints for adaptive shell (see docs/ui-adaptive-plan.md).
library;

import 'package:flutter/widgets.dart';

enum GwWindowSize { compact, medium, expanded }

abstract final class GwBreakpoints {
  static const double compactMax = 600;
  static const double mediumMax = 1024;

  /// Content max width for Home / Settings.
  static const double contentMax = 840;

  /// Wider content for Profiles list.
  static const double contentMaxWide = 1100;

  static GwWindowSize ofWidth(double width) {
    if (width < compactMax) return GwWindowSize.compact;
    if (width < mediumMax) return GwWindowSize.medium;
    return GwWindowSize.expanded;
  }

  static GwWindowSize of(BuildContext context) =>
      ofWidth(MediaQuery.sizeOf(context).width);

  /// Side rail/sidebar from tablet width up. Phone (`compact`) keeps bottom nav.
  static bool useSideNav(GwWindowSize size) =>
      size == GwWindowSize.medium || size == GwWindowSize.expanded;

  /// Labels on rail only on desktop-wide; tablet medium = icons + tooltip.
  static bool sideNavExtended(GwWindowSize size) =>
      size == GwWindowSize.expanded;
}
