import 'dart:ui';

import 'package:flutter/foundation.dart';

/// Default numeric values for the ambient background layer. Centralised
/// here so the theme extension (`LiquidScaffoldThemeData`) and the
/// runtime widget (`LiquidBackground`) reference a single source of truth.
abstract final class LiquidBackgroundDefaults {
  static const int defaultBlobCount = 3;
  static const double defaultMaxBlurSigma = 60.0;
  static const double defaultMaxRadiusFraction = 0.45;
  static const double defaultOpacityMin = 0.05;
  static const double defaultOpacityMax = 0.18;
  static const Duration defaultAmbientDuration = Duration(seconds: 18);
  static const Duration defaultImageBlurDuration = Duration(milliseconds: 240);
}

/// Per-scaffold ambient background configuration. Defaults to disabled so
/// a screen stays cheap unless the caller explicitly opts in. When
/// [enabled] is true, [LiquidBackground] mounts 2–3 soft blurred circles
/// ("light blobs") and drives them with a slow internal animation.
@immutable
class AmbientBackgroundStyle {
  const AmbientBackgroundStyle({
    this.enabled = false,
    this.tint,
    this.blobCount = LiquidBackgroundDefaults.defaultBlobCount,
    this.maxBlurSigma = LiquidBackgroundDefaults.defaultMaxBlurSigma,
    this.maxRadiusFraction = LiquidBackgroundDefaults.defaultMaxRadiusFraction,
    this.opacityMin = LiquidBackgroundDefaults.defaultOpacityMin,
    this.opacityMax = LiquidBackgroundDefaults.defaultOpacityMax,
    this.duration = LiquidBackgroundDefaults.defaultAmbientDuration,
  });

  /// When true, the background paints ambient light blobs. When false,
  /// the background is a static gradient + optional image (no controller).
  final bool enabled;

  /// Optional override for the blob tint. When null, the blob reads
  /// `LiquidTheme.lightReflectionColor` (a soft white) so the brand
  /// accent never floods the surface — design doc §6 forbids accent fills.
  final Color? tint;

  final int blobCount;
  final double maxBlurSigma;
  final double maxRadiusFraction;
  final double opacityMin;
  final double opacityMax;
  final Duration duration;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AmbientBackgroundStyle &&
          enabled == other.enabled &&
          tint == other.tint &&
          blobCount == other.blobCount &&
          maxBlurSigma == other.maxBlurSigma &&
          maxRadiusFraction == other.maxRadiusFraction &&
          opacityMin == other.opacityMin &&
          opacityMax == other.opacityMax &&
          duration == other.duration;

  @override
  int get hashCode => Object.hash(
        enabled,
        tint,
        blobCount,
        maxBlurSigma,
        maxRadiusFraction,
        opacityMin,
        opacityMax,
        duration,
      );
}
