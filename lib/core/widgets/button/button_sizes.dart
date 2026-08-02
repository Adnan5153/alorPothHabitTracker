import 'package:flutter/material.dart';

import '../../liquidGlass/transitions/liquid_transition.dart';

/// Responsive layout metrics for the reusable button system.
class AppButtonSizes {
  AppButtonSizes._();

  static const double padVSmall = 10;
  static const double padVMedium = 14;
  static const double padVLarge = 18;
  static const double padH = 24;
  static const double minTouchTarget = 48;
  static const double iconSmall = 16;
  static const double iconMedium = 18;
  static const double iconLarge = 22;
  static const double iconLabelGap = 8;
  static const double loadingSize = 20;
  static const double loadingStroke = 2.4;
  static const double fontSizeSmall = 14;
  static const double fontSizeMedium = 16;
  static const double fontSizeLarge = 18;
}

/// Motion tokens shared with the Liquid Glass interaction layer.
class AppButtonDurations {
  AppButtonDurations._();

  static const Duration tapFeedback = LiquidMotion.press;
  static const Curve curve = LiquidMotion.pressCurve;
}
