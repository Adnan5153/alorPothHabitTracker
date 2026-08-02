import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class LogoIllustration extends StatelessWidget {
  const LogoIllustration({
    super.key,
    required this.glowProgress,
    required this.scaleProgress,
    required this.isDark,
  });

  final double glowProgress;
  final double scaleProgress;
  final bool isDark;

  static const String _lightAsset = 'assets/images/logo_light_mode.png';
  static const String _darkAsset = 'assets/images/logo_night_mode.png';

  @override
  Widget build(BuildContext context) {
    final scale = AppSizes.splashScaleMin + AppSizes.splashScaleGain * scaleProgress;
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: glowProgress,
          child: _Glow(isDark: isDark, intensity: glowProgress),
        ),
        Transform.scale(
          scale: scale,
          child: Image.asset(
            isDark ? _darkAsset : _lightAsset,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.isDark, required this.intensity});

  final bool isDark;
  final double intensity;

  @override
  Widget build(BuildContext context) {
    final color = isDark
        ? AppColors.pathStart.withValues(alpha: AppSizes.horizonGlowAlphaDark)
        : AppColors.sunStart.withValues(alpha: AppSizes.horizonGlowAlphaLight);
    final size = AppSizes.splashGlowBase + AppSizes.splashGlowGrow * intensity;
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0.0)],
            stops: const [0.0, 1.0],
          ),
        ),
      ),
    );
  }
}
