import 'package:flutter/material.dart';

import '../../constants/app_radius.dart';
import '../../liquidGlass/effects/liquid_glass_effect.dart';
import '../../liquidGlass/theme/liquid_theme.dart';
import '../../liquidGlass/transitions/liquid_transition.dart';
import 'button_content.dart';
import 'button_extensions.dart';
import 'button_sizes.dart';

export 'primary_button.dart';

/// Tonal Liquid Glass button for secondary actions.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isExpanded = true,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonSize size;
  final bool isLoading;
  final bool isExpanded;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final liquidTheme = LiquidThemes.of(context);
    final scheme = Theme.of(context).colorScheme;
    final palette = liquidTheme.toButtonPalette(scheme);
    final disabled = isLoading || onPressed == null;
    final metrics = ButtonMetrics.of(size.forContext(context));
    final foreground = disabled ? palette.disabled : scheme.onSurface;

    final surface = LiquidGlassEffect(
      baseColor: liquidTheme.surfaceTint,
      borderRadius: AppRadius.button,
      borderColor: palette.border,
      surfaceOpacity: disabled ? 0.06 : liquidTheme.surfaceOpacity * 0.75,
      reflectionIntensity:
          disabled ? 0.08 : liquidTheme.reflectionIntensity * 0.7,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppButtonSizes.minTouchTarget),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppButtonSizes.padH,
            vertical: metrics.verticalPadding,
          ),
          child: Center(
            child: ButtonContent(
              label: label,
              loading: isLoading,
              leadingIcon: icon,
              foreground: foreground,
              metrics: metrics,
            ),
          ),
        ),
      ),
    );

    final button = Semantics(
      label: semanticLabel ?? label,
      button: true,
      enabled: !disabled,
      child: IgnorePointer(
        ignoring: disabled,
        child: LiquidPressController(
          enabled: !disabled,
          onPressed: disabled ? null : onPressed,
          child: (context, animation, _) => LiquidTransition(
            animation: animation,
            beginScale: 0.98,
            fade: false,
            child: surface,
          ),
        ),
      ),
    );

    return isExpanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}