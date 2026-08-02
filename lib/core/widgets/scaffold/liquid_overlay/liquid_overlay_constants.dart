import '../../../widgets/button/button_sizes.dart';

abstract final class LiquidOverlayDefaults {
  static const double loadingDiscPadding = 12;
  static const Duration loadingFadeDuration = Duration(milliseconds: 180);
  static const double overlayScrimOpacity = 0.32;

  // Mirror button loading chrome tokens.
  static const double loadingDiscSize = AppButtonSizes.minTouchTarget;
  static const double loadingSpinnerStroke = AppButtonSizes.loadingStroke;
  static const double loadingSpinnerDiameter = AppButtonSizes.loadingSize;
}
