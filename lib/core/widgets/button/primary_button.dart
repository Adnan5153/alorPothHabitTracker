import 'package:flutter/material.dart';

import '../../liquidGlass/effects/liquid_glass_effect.dart';
import '../../liquidGlass/theme/liquid_theme.dart';
import '../../liquidGlass/transitions/liquid_transition.dart';
import 'button_content.dart';
import 'button_extensions.dart';
import 'button_sizes.dart';

export 'secondary_button.dart';

/// Filled Liquid Glass call-to-action button for the highest-emphasis action.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.leadingIcon,
    this.trailingIcon,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isExpanded = true,
    this.semanticLabel,
    this.child,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final ButtonSize size;
  final bool isLoading;
  final bool isExpanded;
  final String? semanticLabel;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final liquidTheme = LiquidThemes.of(context);
    final palette = liquidTheme.toButtonPalette(Theme.of(context).colorScheme);
    final disabled = isLoading || onPressed == null;
    final metrics = ButtonMetrics.of(size.forContext(context));
    final foreground = disabled ? palette.disabled : palette.onAccent;
    final surfaceColor = disabled ? palette.disabledSurface : palette.accent;

    final content = child ??
        ButtonContent(
          label: label,
          loading: isLoading,
          leadingIcon: leadingIcon ?? icon,
          trailingIcon: trailingIcon,
          foreground: foreground,
          metrics: metrics,
        );

    final surface = LiquidGlassEffect(
      baseColor: surfaceColor,
      borderRadius: liquidTheme.borderRadius.clamp(0.0, 96.0),
      borderColor: palette.reflection,
      surfaceOpacity: disabled ? 0.08 : liquidTheme.surfaceOpacity,
      reflectionIntensity: disabled ? 0.12 : liquidTheme.reflectionIntensity,
      boxShadow: disabled
          ? null
          : [
              BoxShadow(
                color: palette.accent.withValues(alpha: 0.18),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppButtonSizes.minTouchTarget),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppButtonSizes.padH,
            vertical: metrics.verticalPadding,
          ),
          child: Center(child: content),
        ),
      ),
    );

    final interactive = LiquidPressController(
      enabled: !disabled,
      onPressed: disabled ? null : onPressed,
      child: (context, animation, _) => LiquidTransition(
        animation: animation,
        beginScale: 0.98,
        fade: false,
        child: surface,
      ),
    );

    final button = Semantics(
      label: semanticLabel ?? label,
      button: true,
      enabled: !disabled,
      child: IgnorePointer(ignoring: disabled, child: interactive),
    );

    return isExpanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
