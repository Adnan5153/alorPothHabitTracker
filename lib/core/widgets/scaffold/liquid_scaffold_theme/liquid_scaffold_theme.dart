import 'package:flutter/material.dart';

import 'liquid_scaffold_theme_data.dart';

/// InheritedWidget that exposes [LiquidScaffoldThemeData] down the tree.
/// `LiquidScaffold` mounts a default instance automatically when none is
/// present, so most consumers never touch this widget directly — they
/// read tokens via `context.liquidScaffoldTheme`.
class LiquidScaffoldTheme extends InheritedWidget {
  const LiquidScaffoldTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final LiquidScaffoldThemeData data;

  static LiquidScaffoldThemeData of(BuildContext context) {
    final inherited = context
        .dependOnInheritedWidgetOfExactType<LiquidScaffoldTheme>();
    assert(
      inherited != null,
      'LiquidScaffoldTheme.of called with a context that does not '
      'contain a LiquidScaffoldTheme ancestor.',
    );
    return inherited!.data;
  }

  static LiquidScaffoldThemeData? maybeOf(BuildContext context) {
    return context
        .getInheritedWidgetOfExactType<LiquidScaffoldTheme>()
        ?.data;
  }

  @override
  bool updateShouldNotify(LiquidScaffoldTheme oldWidget) =>
      data != oldWidget.data;
}
