import 'package:flutter/material.dart';

import '../../liquidGlass/exports.dart';
import 'app_bar_constants.dart';

/// Reusable tappable icon used as the building block for every
/// specialised AppBar action (search, notification, theme, custom).
/// Wraps [LiquidTapSurface] so the click target inherits the shared
/// Liquid Glass treatment without each call site re-implementing it.
class AppBarActionButton extends StatelessWidget {
  const AppBarActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.color,
    this.iconSize,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final effectiveColor = color ?? scheme.onSurface;
    return LiquidTapSurface(
      tooltip: tooltip ?? 'Action',
      semanticLabel: tooltip ?? 'Action',
      onTap: onPressed,
      padding: const EdgeInsets.all(AppBarSizes.actionSpacing),
      borderRadius: BorderRadius.circular(14),
      child: Icon(
        icon,
        size: iconSize ?? AppBarSizes.iconSize,
        color: effectiveColor,
      ),
    );
  }
}