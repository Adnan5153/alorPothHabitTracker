import 'package:flutter/material.dart';

import '../../../animations/app_animations.dart';
import '../../../liquidGlass/effects/liquid_glass_effect.dart';
import '../../../liquidGlass/theme/liquid_theme.dart';
import '../../button/button_extensions.dart';
import '../liquid_scaffold_extensions/liquid_scaffold_context_extensions.dart';
import 'liquid_overlay_constants.dart';

/// Centred loading chrome — a hairline-glass disc with a themed spinner
/// inside. Reads every visual value from `LiquidTheme` and the scaffold
/// theme tokens.
class LiquidLoading extends StatelessWidget {
  const LiquidLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = LiquidThemes.of(context);
    final tokens = context.liquidScaffoldTheme;
    final palette = context.buttonPalette;

    final disc = LiquidGlassEffect(
      blurStrength: theme.blurStrength,
      borderColor: theme.borderColor,
      borderRadius: tokens.loadingDiscSize,
      borderWidth: 0.6,
      surfaceOpacity: theme.surfaceOpacity,
      reflectionIntensity: theme.reflectionIntensity,
      padding: const EdgeInsets.all(LiquidOverlayDefaults.loadingDiscPadding),
      child: SizedBox(
        width: tokens.loadingSpinnerDiameter,
        height: tokens.loadingSpinnerDiameter,
        child: CircularProgressIndicator(
          strokeWidth: tokens.loadingSpinnerStroke,
          valueColor: AlwaysStoppedAnimation<Color>(palette.onAccent),
        ),
      ),
    );

    return Center(child: disc.fadeInMicro());
  }
}