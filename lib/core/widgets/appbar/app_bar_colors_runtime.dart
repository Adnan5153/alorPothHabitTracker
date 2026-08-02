import 'package:flutter/material.dart';

import 'app_bar_extensions.dart';

/// Pre-resolved colour bundle sourced from the active [ColorScheme]. The
/// AppBar widgets snapshot these values once per build to avoid repeated
/// theme lookups and to give every child a consistent palette.
@immutable
class AppBarColorsRuntime {
  const AppBarColorsRuntime({
    required this.foreground,
    required this.background,
    required this.muted,
    required this.surfaceTint,
    required this.primary,
    required this.onPrimary,
    required this.titleStyle,
  });

  factory AppBarColorsRuntime.of(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final titleStyle =
        AppBarColors.titleTextStyle(context).copyWith(color: scheme.onSurface);
    return AppBarColorsRuntime(
      foreground: scheme.onSurface,
      background: scheme.surface,
      muted: scheme.onSurfaceVariant,
      surfaceTint: scheme.surfaceTint,
      primary: scheme.primary,
      onPrimary: scheme.onPrimary,
      titleStyle: titleStyle,
    );
  }

  final Color foreground;
  final Color background;
  final Color muted;
  final Color surfaceTint;
  final Color primary;
  final Color onPrimary;
  final TextStyle titleStyle;
}
