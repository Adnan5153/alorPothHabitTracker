import '../glass_container/constants.dart';

/// Layout, spacing and timing constants used by [GlassPrimaryButton].
class GlassPrimaryButtonConstants {
  GlassPrimaryButtonConstants._();

  // Vertical padding scales with [GlassSize].
  static const double padVSmall = 10;
  static const double padVMedium = 14;
  static const double padVLarge = 18;

  // Horizontal padding (predictable alignment with neighbouring buttons).
  static const double padH = 24;

  // Min tap target.
  static const double minTouchTarget = GlassConstants.minTouchTarget;

  // Icon sizing.
  static const double iconSmall = 16;
  static const double iconMedium = 18;
  static const double iconLarge = 22;

  // Gap between label and icon.
  static const double iconLabelGap = GlassConstants.space8;

  // Loading indicator.
  static const double loadingSize = 20;
  static const double loadingStroke = 2.4;

  // Press feedback.
  static const double pressScale = 0.97;
  static const Duration tapFeedback = Duration(milliseconds: 150);
}