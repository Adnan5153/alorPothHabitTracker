import 'package:flutter/material.dart';

/// Spacing, radius, blur, opacity and timing constants used across the
/// Glass UI library. Centralising these keeps the entire glass surface
/// visually consistent and prevents magic numbers from drifting.
class GlassConstants {
  GlassConstants._();

  // Spacing scale (mirrors the AppSizes 4-pt grid).
  static const double space4 = 4;
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;
  static const double space32 = 32;

  // Adaptive blur values (sigma X = sigma Y).
  static const double blurLight = 8;
  static const double blurStandard = 16;
  static const double blurHeavy = 24;
  static const double blurPopup = 18;

  // Surface opacity bands for the glass tint.
  static const double tintAlphaLight = 0.55;
  static const double tintAlphaDark = 0.30;
  static const double tintAlphaSubtle = 0.18;
  static const double tintAlphaBold = 0.72;

  // Border opacity.
  static const double borderAlphaLight = 0.55;
  static const double borderAlphaDark = 0.30;

  // Border width.
  static const double borderThin = 0.6;
  static const double borderStandard = 1.0;
  static const double borderThick = 1.4;

  // Shadow.
  static const double shadowBlurSmall = 8;
  static const double shadowBlurMedium = 18;
  static const double shadowBlurLarge = 28;
  static const double shadowAlphaLight = 0.10;
  static const double shadowAlphaDark = 0.35;

  // Corner radius (progressive glass scale).
  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 20;
  static const double radiusXl = 28;
  static const double radiusPill = 999;

  // Min touch target (Material guideline).
  static const double minTouchTarget = 48;

  // Animation timings.
  static const Duration animMicro = Duration(milliseconds: 180);
  static const Duration animStandard = Duration(milliseconds: 320);
  static const Duration animPage = Duration(milliseconds: 420);
  static const Curve animCurve = Curves.easeOutCubic;
  static const Curve animCurveSubtle = Curves.easeInOut;
}

/// Visual weight/size variants for any glass widget that supports
/// responsive sizing (GlassCard, GlassSummaryCard, GlassPrimaryButton).
enum GlassSize { small, medium, large }

extension GlassResponsiveSize on GlassSize {
  /// Bumps the requested size up by one tier on tablet/desktop so that
  /// touch targets and typography stay comfortable without screens
  /// having to size themselves.
  GlassSize forContext(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1024) {
      return switch (this) {
        GlassSize.small => GlassSize.medium,
        GlassSize.medium => GlassSize.large,
        GlassSize.large => GlassSize.large,
      };
    }
    if (width >= 600) {
      return switch (this) {
        GlassSize.small => GlassSize.medium,
        GlassSize.medium => GlassSize.medium,
        GlassSize.large => GlassSize.large,
      };
    }
    return this;
  }
}