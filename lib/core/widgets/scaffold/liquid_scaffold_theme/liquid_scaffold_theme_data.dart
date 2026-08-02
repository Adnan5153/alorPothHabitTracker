import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../../../constants/app_sizes.dart';
import '../../../widgets/button/button_sizes.dart';
import '../liquid_background/liquid_background_constants.dart';

@immutable
class LiquidScaffoldResponsivePadding {
  const LiquidScaffoldResponsivePadding({
    this.compact = AppSizes.space24,
    this.tablet = AppSizes.space32,
    this.desktop = AppSizes.space40,
  });

  final double compact;
  final double tablet;
  final double desktop;
}

/// Scaffold-level design tokens. Every `LiquidScaffold` reads these via
/// `LiquidScaffoldTheme.of(context)` (or `context.liquidScaffoldTheme`).
/// Brightness-agnostic numeric values — theme-aware tints flow through
/// `LiquidTheme`, not this extension.
@immutable
class LiquidScaffoldThemeData extends ThemeExtension<LiquidScaffoldThemeData> {
  const LiquidScaffoldThemeData({
    this.horizontalPadding = AppSizes.screenPaddingHorizontal,
    this.verticalPadding = AppSizes.screenPaddingVertical,
    this.responsiveVerticalPadding = const LiquidScaffoldResponsivePadding(),
    this.ambientBlobCount = LiquidBackgroundDefaults.defaultBlobCount,
    this.ambientBlobMaxBlurSigma = LiquidBackgroundDefaults.defaultMaxBlurSigma,
    this.ambientBlobMaxRadiusFraction =
        LiquidBackgroundDefaults.defaultMaxRadiusFraction,
    this.ambientBlobOpacityMin = LiquidBackgroundDefaults.defaultOpacityMin,
    this.ambientBlobOpacityMax = LiquidBackgroundDefaults.defaultOpacityMax,
    this.ambientAnimationDuration =
        LiquidBackgroundDefaults.defaultAmbientDuration,
    this.loadingDiscSize = AppButtonSizes.minTouchTarget,
    this.loadingSpinnerStroke = AppButtonSizes.loadingStroke,
    this.loadingSpinnerDiameter = AppButtonSizes.loadingSize,
    this.overlayScrimOpacity = 0.32,
    this.imageBlurSigma = 22.0,
  });

  final double horizontalPadding;
  final double verticalPadding;
  final LiquidScaffoldResponsivePadding responsiveVerticalPadding;

  final int ambientBlobCount;
  final double ambientBlobMaxBlurSigma;
  final double ambientBlobMaxRadiusFraction;
  final double ambientBlobOpacityMin;
  final double ambientBlobOpacityMax;
  final Duration ambientAnimationDuration;

  final double loadingDiscSize;
  final double loadingSpinnerStroke;
  final double loadingSpinnerDiameter;

  final double overlayScrimOpacity;
  final double imageBlurSigma;

  static const LiquidScaffoldThemeData light = LiquidScaffoldThemeData();
  static const LiquidScaffoldThemeData dark = LiquidScaffoldThemeData();

  @override
  LiquidScaffoldThemeData copyWith({
    double? horizontalPadding,
    double? verticalPadding,
    LiquidScaffoldResponsivePadding? responsiveVerticalPadding,
    int? ambientBlobCount,
    double? ambientBlobMaxBlurSigma,
    double? ambientBlobMaxRadiusFraction,
    double? ambientBlobOpacityMin,
    double? ambientBlobOpacityMax,
    Duration? ambientAnimationDuration,
    double? loadingDiscSize,
    double? loadingSpinnerStroke,
    double? loadingSpinnerDiameter,
    double? overlayScrimOpacity,
    double? imageBlurSigma,
  }) {
    return LiquidScaffoldThemeData(
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
      responsiveVerticalPadding:
          responsiveVerticalPadding ?? this.responsiveVerticalPadding,
      ambientBlobCount: ambientBlobCount ?? this.ambientBlobCount,
      ambientBlobMaxBlurSigma:
          ambientBlobMaxBlurSigma ?? this.ambientBlobMaxBlurSigma,
      ambientBlobMaxRadiusFraction:
          ambientBlobMaxRadiusFraction ?? this.ambientBlobMaxRadiusFraction,
      ambientBlobOpacityMin:
          ambientBlobOpacityMin ?? this.ambientBlobOpacityMin,
      ambientBlobOpacityMax:
          ambientBlobOpacityMax ?? this.ambientBlobOpacityMax,
      ambientAnimationDuration:
          ambientAnimationDuration ?? this.ambientAnimationDuration,
      loadingDiscSize: loadingDiscSize ?? this.loadingDiscSize,
      loadingSpinnerStroke: loadingSpinnerStroke ?? this.loadingSpinnerStroke,
      loadingSpinnerDiameter:
          loadingSpinnerDiameter ?? this.loadingSpinnerDiameter,
      overlayScrimOpacity: overlayScrimOpacity ?? this.overlayScrimOpacity,
      imageBlurSigma: imageBlurSigma ?? this.imageBlurSigma,
    );
  }

  @override
  LiquidScaffoldThemeData lerp(
    ThemeExtension<LiquidScaffoldThemeData>? other,
    double t,
  ) {
    if (other is! LiquidScaffoldThemeData) return this;
    return LiquidScaffoldThemeData(
      horizontalPadding:
          lerpDouble(horizontalPadding, other.horizontalPadding, t)!,
      verticalPadding:
          lerpDouble(verticalPadding, other.verticalPadding, t)!,
      responsiveVerticalPadding: LiquidScaffoldResponsivePadding(
        compact: lerpDouble(
          responsiveVerticalPadding.compact,
          other.responsiveVerticalPadding.compact,
          t,
        )!,
        tablet: lerpDouble(
          responsiveVerticalPadding.tablet,
          other.responsiveVerticalPadding.tablet,
          t,
        )!,
        desktop: lerpDouble(
          responsiveVerticalPadding.desktop,
          other.responsiveVerticalPadding.desktop,
          t,
        )!,
      ),
      ambientBlobCount: t < 0.5 ? ambientBlobCount : other.ambientBlobCount,
      ambientBlobMaxBlurSigma: lerpDouble(
        ambientBlobMaxBlurSigma,
        other.ambientBlobMaxBlurSigma,
        t,
      )!,
      ambientBlobMaxRadiusFraction: lerpDouble(
        ambientBlobMaxRadiusFraction,
        other.ambientBlobMaxRadiusFraction,
        t,
      )!,
      ambientBlobOpacityMin: lerpDouble(
        ambientBlobOpacityMin,
        other.ambientBlobOpacityMin,
        t,
      )!,
      ambientBlobOpacityMax: lerpDouble(
        ambientBlobOpacityMax,
        other.ambientBlobOpacityMax,
        t,
      )!,
      ambientAnimationDuration: Duration(
        milliseconds: _lerpInt(
          ambientAnimationDuration.inMilliseconds,
          other.ambientAnimationDuration.inMilliseconds,
          t,
        ),
      ),
      loadingDiscSize:
          lerpDouble(loadingDiscSize, other.loadingDiscSize, t)!,
      loadingSpinnerStroke:
          lerpDouble(loadingSpinnerStroke, other.loadingSpinnerStroke, t)!,
      loadingSpinnerDiameter:
          lerpDouble(loadingSpinnerDiameter, other.loadingSpinnerDiameter, t)!,
      overlayScrimOpacity:
          lerpDouble(overlayScrimOpacity, other.overlayScrimOpacity, t)!,
      imageBlurSigma: lerpDouble(imageBlurSigma, other.imageBlurSigma, t)!,
    );
  }
}

int _lerpInt(int a, int b, double t) => (a + (b - a) * t).round();
