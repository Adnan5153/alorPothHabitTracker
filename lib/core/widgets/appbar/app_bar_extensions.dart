import 'package:flutter/material.dart';

import 'app_bar_constants.dart';

/// Predefined AppBar presets covering every supported screen type.
enum AppBarVariant {
  defaultBar,
  dashboard,
  profile,
  search,
  transparent,
  gradient,
  largeTitle,
  centered,
  minimal,
  settings,
  details,
  ai,
  statistics,
  calendar,
  leaderboard,
}

/// Behavioural and visual presets applied on top of the public AppBar API.
extension AppBarVariantPreset on AppBarVariant {
  bool get showBackButton => switch (this) {
        AppBarVariant.details ||
        AppBarVariant.ai ||
        AppBarVariant.minimal ||
        AppBarVariant.statistics ||
        AppBarVariant.calendar ||
        AppBarVariant.leaderboard =>
          true,
        _ => false,
      };

  bool get centerTitle => switch (this) {
        AppBarVariant.centered ||
        AppBarVariant.dashboard ||
        AppBarVariant.ai ||
        AppBarVariant.calendar ||
        AppBarVariant.statistics =>
          true,
        _ => false,
      };

  bool get pinned => switch (this) {
        AppBarVariant.largeTitle ||
        AppBarVariant.profile ||
        AppBarVariant.details ||
        AppBarVariant.ai ||
        AppBarVariant.dashboard ||
        AppBarVariant.statistics ||
        AppBarVariant.calendar ||
        AppBarVariant.leaderboard =>
          true,
        _ => false,
      };

  bool get floating => this == AppBarVariant.search;
  bool get snap => this == AppBarVariant.search;

  bool get stretch => switch (this) {
        AppBarVariant.profile ||
        AppBarVariant.dashboard ||
        AppBarVariant.largeTitle =>
          true,
        _ => false,
      };

  bool get transparent =>
      this == AppBarVariant.transparent || this == AppBarVariant.largeTitle;
  bool get gradient => this == AppBarVariant.gradient;
  bool get showSearch =>
      this == AppBarVariant.search || this == AppBarVariant.dashboard;
  bool get showNotification =>
      this == AppBarVariant.dashboard || this == AppBarVariant.profile;
  bool get showTheme =>
      this == AppBarVariant.settings || this == AppBarVariant.defaultBar;
  bool get showAvatar =>
      this == AppBarVariant.profile || this == AppBarVariant.dashboard;

  double get expandedHeight => switch (this) {
        AppBarVariant.largeTitle => AppBarSizes.expandedHeightLarge,
        AppBarVariant.profile => AppBarSizes.expandedHeightMedium,
        AppBarVariant.details => AppBarSizes.expandedHeightMedium,
        _ => AppBarSizes.expandedHeightSmall,
      };
}

/// Responsive helpers scoped to BuildContext for toolbar height and
/// breakpoint detection across phone, tablet and desktop.
extension AppBarResponsive on BuildContext {
  double get appBarHeight {
    final width = MediaQuery.sizeOf(this).width;
    if (width >= AppBarSizes.desktopBreakpoint) {
      return AppBarSizes.toolbarHeightDesktop;
    }
    if (width >= AppBarSizes.tabletBreakpoint) {
      return AppBarSizes.toolbarHeightTablet;
    }
    return AppBarSizes.toolbarHeight;
  }

  bool get isCompact =>
      MediaQuery.sizeOf(this).width < AppBarSizes.tabletBreakpoint;

  bool get isTablet {
    final width = MediaQuery.sizeOf(this).width;
    return width >= AppBarSizes.tabletBreakpoint &&
        width < AppBarSizes.desktopBreakpoint;
  }

  bool get isDesktop =>
      MediaQuery.sizeOf(this).width >= AppBarSizes.desktopBreakpoint;
}

/// Centralised theme-driven colour and text-style lookups used by every
/// AppBar widget. Keeping these in one place prevents colour or typography
/// drift across the AppBar surface.
class AppBarColors {
  AppBarColors._();

  static Color foreground(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  static Color background(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  static Color muted(BuildContext context) =>
      Theme.of(context).colorScheme.onSurfaceVariant;

  static Color surfaceTint(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceTint;

  static TextStyle titleTextStyle(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge ??
      const TextStyle(
        fontSize: AppBarSizes.compactTitleFontSize,
        fontWeight: FontWeight.w600,
      );
}
