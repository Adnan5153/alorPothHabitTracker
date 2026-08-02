import 'package:flutter/material.dart';

import '../../liquidGlass/theme/liquid_theme.dart';
import 'button_sizes.dart';

/// Visual size variants supported by the button family.
enum ButtonSize { small, medium, large }

/// Behavioural intent used by Widget Builder previews.
enum ButtonVariant { primary, secondary }

@immutable
class ButtonMetrics {
  const ButtonMetrics({
    required this.verticalPadding,
    required this.iconSize,
  });

  factory ButtonMetrics.of(ButtonSize size) {
    return switch (size) {
      ButtonSize.small => const ButtonMetrics(
          verticalPadding: AppButtonSizes.padVSmall,
          iconSize: AppButtonSizes.iconSmall,
        ),
      ButtonSize.medium => const ButtonMetrics(
          verticalPadding: AppButtonSizes.padVMedium,
          iconSize: AppButtonSizes.iconMedium,
        ),
      ButtonSize.large => const ButtonMetrics(
          verticalPadding: AppButtonSizes.padVLarge,
          iconSize: AppButtonSizes.iconLarge,
        ),
    };
  }

  final double verticalPadding;
  final double iconSize;
}

extension ButtonResponsiveSize on ButtonSize {
  ButtonSize forContext(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1024) {
      return this == ButtonSize.large ? this : ButtonSize.large;
    }
    if (width >= 600) {
      return this == ButtonSize.small ? ButtonSize.medium : this;
    }
    return this;
  }
}

extension ButtonThemeX on BuildContext {
  LiquidTheme get liquidTheme => LiquidThemes.of(this);
  ButtonPalette get buttonPalette =>
      liquidTheme.toButtonPalette(Theme.of(this).colorScheme);
}
