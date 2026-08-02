import 'package:flutter/material.dart';

/// Layout, spacing, typography, and breakpoint constants used across the
/// reusable AppBar system.
class AppBarSizes {
  AppBarSizes._();

  static const double toolbarHeight = 56;
  static const double toolbarHeightTablet = 64;
  static const double toolbarHeightDesktop = 72;

  static const double collapsedHeight = 56;
  static const double expandedHeightLarge = 220;
  static const double expandedHeightMedium = 160;
  static const double expandedHeightSmall = 120;

  static const double iconSize = 24;
  static const double iconSizeCompact = 20;

  static const double actionSpacing = 4;
  static const double titleHorizontalPadding = 8;
  static const double titleVerticalPadding = 4;

  static const double avatarRadius = 18;
  static const double avatarDiameter = 36;

  static const double notificationBadgeSize = 18;
  static const double notificationBadgeText = 10;

  static const double minTouchTarget = 48;

  static const double largeTitleFontSize = 28;
  static const double compactTitleFontSize = 18;

  static const double tabletBreakpoint = 600;
  static const double desktopBreakpoint = 1024;
}

/// Animation durations and curves for the AppBar system.
class AppBarDurations {
  AppBarDurations._();

  static const Duration standard = Duration(milliseconds: 250);
  static const Duration fast = Duration(milliseconds: 150);
  static const Curve curve = Curves.easeInOut;
}
