import 'package:flutter/widgets.dart';

import '../liquid_scaffold_theme/liquid_scaffold_theme.dart';
import '../liquid_scaffold_theme/liquid_scaffold_theme_data.dart';

/// Sugar so screens never import the [LiquidScaffoldTheme] InheritedWidget
/// directly.
extension LiquidScaffoldContextX on BuildContext {
  LiquidScaffoldThemeData get liquidScaffoldTheme =>
      LiquidScaffoldTheme.of(this);

  LiquidScaffoldThemeData? get maybeLiquidScaffoldTheme =>
      LiquidScaffoldTheme.maybeOf(this);

  bool get hasLiquidScaffoldTheme =>
      LiquidScaffoldTheme.maybeOf(this) != null;
}
