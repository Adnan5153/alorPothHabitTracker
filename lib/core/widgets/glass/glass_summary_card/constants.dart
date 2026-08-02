import 'package:flutter/material.dart';

import '../glass_container/constants.dart';

/// Layout, typography and animation tokens for the [GlassSummaryCard]
/// family. Centralised so visual language can evolve independently of
/// the render layer.
class GlassSummaryCardConstants {
  GlassSummaryCardConstants._();

  // Vertical layout rhythm.
  static const double labelGap = GlassConstants.space4;
  static const double valueGap = GlassConstants.space4;
  static const double subtitleGap = GlassConstants.space4;
  static const double statusGap = GlassConstants.space8;
  static const double chartGap = GlassConstants.space12;

  // Card surface.
  static const double cardRadius = GlassConstants.radiusLg;
  static const double borderWidth = 0.6;
  static const double pressScale = 0.985;

  // Icon container.
  static const double iconContainerSizeSmall = 36;
  static const double iconContainerSizeMedium = 44;
  static const double iconContainerSizeLarge = 52;
  static const double iconSizeSmall = 18;
  static const double iconSizeMedium = 22;
  static const double iconSizeLarge = 26;

  // Value typography.
  static const double valueSizeSmall = 22;
  static const double valueSizeMedium = 30;
  static const double valueSizeLarge = 38;
  static const double labelSize = 12;
  static const double subtitleSize = 12;
  static const double badgeFontSize = 11;

  // Progress indicator.
  static const double progressHeight = 6;
  static const double progressTrackAlpha = 1.2;

  // Status badge.
  static const double badgeHeight = 22;
  static const double badgeRadius = 11;
  static const double badgeHorizontalPadding = 10;
  static const double badgeAlpha = 0.14;
  static const double badgeBorderAlpha = 0.32;

  // Trend arrow.
  static const double trendIndicatorSize = 14;
  static const double trendIndicatorGap = 4;

  // Number animation.
  static const Duration numberAnimation = Duration(milliseconds: 700);
  static const Curve numberCurve = Curves.easeOutCubic;
  static const double numberMoveY = 6;
}