import 'package:flutter/material.dart';

import '../../liquidGlass/theme/liquid_theme.dart';
import 'button_extensions.dart';
import 'button_sizes.dart';

/// Internal label/loading renderer shared by every button in this module.
/// Keeps the loading → label transition and icon alignment consistent.
class ButtonContent extends StatelessWidget {
  const ButtonContent({
    super.key,
    required this.label,
    required this.loading,
    required this.foreground,
    required this.metrics,
    this.leadingIcon,
    this.trailingIcon,
    this.fontSize = AppButtonSizes.fontSizeMedium,
  });

  final String label;
  final bool loading;
  final Color foreground;
  final ButtonMetrics metrics;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return SizedBox(
        key: const ValueKey('button-loading'),
        height: AppButtonSizes.loadingSize,
        width: AppButtonSizes.loadingSize,
        child: CircularProgressIndicator(
          strokeWidth: AppButtonSizes.loadingStroke,
          valueColor: AlwaysStoppedAnimation<Color>(foreground),
        ),
      );
    }

    final text = Text(
      label,
      key: const ValueKey('button-label'),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: LiquidThemes.of(context).textStyle.copyWith(
            color: foreground,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
    );

    if (leadingIcon == null && trailingIcon == null) return text;

    return Row(
      key: const ValueKey('button-icon-label'),
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: metrics.iconSize, color: foreground),
          const SizedBox(width: AppButtonSizes.iconLabelGap),
        ],
        Flexible(child: text),
        if (trailingIcon != null) ...[
          const SizedBox(width: AppButtonSizes.iconLabelGap),
          Icon(trailingIcon, size: metrics.iconSize, color: foreground),
        ],
      ],
    );
  }
}
