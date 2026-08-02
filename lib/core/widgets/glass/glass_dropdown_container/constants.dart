import 'package:flutter/material.dart';

import '../glass_container/constants.dart';

/// Layout, animation and sizing tokens for [GlassDropdownContainer].
class GlassDropdownContainerConstants {
  GlassDropdownContainerConstants._();

  static const double padV = GlassConstants.space8;
  static const double maxHeight = 320;
  static const double minHeight = 64;
  static const double itemGap = GlassConstants.space4;
  static const double itemVerticalPadding = GlassConstants.space12;
  static const double itemHorizontalPadding = GlassConstants.space16;
  static const double itemIconSize = 18;
  static const double itemTrailingIconSize = 16;
  static const double emptyHeight = GlassConstants.minTouchTarget * 1.4;
  static const double loadingHeight = GlassConstants.minTouchTarget;
  static const Duration openAnim = GlassConstants.animStandard;
  static const Curve openCurve = GlassConstants.animCurve;
  static const double openScale = 0.985;
  static const double openSlideY = -0.04;
  static const double checkIconSize = 18;
  static const double subtitleGap = 2;
  static const double highlightAlpha = 0.20;
  static const double highlightBaseAlpha = 0.0;
  static const double borderWidth = 0.6;
}
