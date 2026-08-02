import 'package:flutter/material.dart';

import 'app_bar_action_button.dart';
import 'app_bar_colors_runtime.dart';
import 'app_bar_constants.dart';

/// Tappable search affordance. Switches colour to highlight the active
/// state when the host screen is a search surface.
class AppBarSearchButton extends StatelessWidget {
  const AppBarSearchButton({
    super.key,
    this.onPressed,
    this.isActive = false,
    this.hint,
  });

  final VoidCallback? onPressed;
  final bool isActive;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final colors = AppBarColorsRuntime.of(context);
    return AppBarActionButton(
      icon: Icons.search_rounded,
      tooltip: hint ?? 'Search',
      color: isActive ? colors.primary : colors.foreground,
      iconSize: AppBarSizes.iconSize,
      onPressed: onPressed,
    );
  }
}
