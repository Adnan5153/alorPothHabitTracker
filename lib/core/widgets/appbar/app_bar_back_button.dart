import 'package:flutter/material.dart';

import '../../liquidGlass/exports.dart';
import 'app_bar_constants.dart';

/// Adaptive leading back button. Renders nothing when the navigator
/// cannot pop and no custom [onPressed] is supplied. The button is
/// rendered through [LiquidTapSurface] so its press feedback matches
/// the rest of the Liquid Glass chrome.
class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({
    super.key,
    this.onPressed,
    this.color,
    this.tooltip,
    this.useRootNavigator = false,
  });

  final VoidCallback? onPressed;
  final Color? color;
  final String? tooltip;
  final bool useRootNavigator;

  @override
  Widget build(BuildContext context) {
    final canPop = useRootNavigator
        ? Navigator.of(context, rootNavigator: true).canPop()
        : Navigator.of(context).canPop();

    if (!canPop && onPressed == null) {
      return const SizedBox.shrink();
    }

    final scheme = Theme.of(context).colorScheme;
    final effectiveColor = color ?? scheme.onSurface;

    final handler = onPressed ??
        () {
          if (useRootNavigator) {
            Navigator.of(context, rootNavigator: true).maybePop();
          } else {
            Navigator.of(context).maybePop();
          }
        };

    return LiquidTapSurface(
      tooltip: tooltip ?? 'Back',
      semanticLabel: tooltip ?? 'Back',
      onTap: handler,
      padding: const EdgeInsets.all(AppBarSizes.actionSpacing),
      borderRadius: BorderRadius.circular(14),
      child: Icon(
        Icons.arrow_back_rounded,
        size: AppBarSizes.iconSize,
        color: effectiveColor,
      ),
    );
  }
}