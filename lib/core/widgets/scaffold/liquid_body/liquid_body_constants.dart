import 'package:flutter/widgets.dart';

import '../../../constants/app_sizes.dart';

/// Default body padding mirrors the platform screen padding tokens so
/// every screen inherits the same inset by default.
abstract final class LiquidBodyDefaults {
  static const EdgeInsets defaultPadding = EdgeInsets.symmetric(
    horizontal: AppSizes.screenPaddingHorizontal,
    vertical: AppSizes.screenPaddingVertical,
  );
}
