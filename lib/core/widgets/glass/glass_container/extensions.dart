import 'models.dart';

/// Adaptive multipliers keyed off [GlassTier]. Lets the Liquid Glass
/// container emphasise or quieten a surface without each call site
/// computing alpha/blur values manually.
extension GlassTierPreset on GlassTier {
  /// Backdrop blur sigma multiplier relative to the active theme baseline.
  double get blurMultiplier {
    return switch (this) {
      GlassTier.subtle => 0.6,
      GlassTier.standard => 1.0,
      GlassTier.bold => 1.45,
      GlassTier.popup => 1.15,
    };
  }

  /// Surface opacity multiplier relative to the active theme baseline.
  double get opacityMultiplier {
    return switch (this) {
      GlassTier.subtle => 0.55,
      GlassTier.standard => 1.0,
      GlassTier.bold => 1.3,
      GlassTier.popup => 1.2,
    };
  }

  /// Shadow intensity multiplier relative to the theme.
  double get shadowMultiplier {
    return switch (this) {
      GlassTier.subtle => 0.7,
      GlassTier.standard => 1.0,
      GlassTier.bold => 1.4,
      GlassTier.popup => 1.15,
    };
  }

  /// Minimum border opacity (light/dark handled inside LiquidGlassEffect).
  double get borderMultiplier {
    return switch (this) {
      GlassTier.subtle => 0.6,
      GlassTier.standard => 1.0,
      GlassTier.bold => 1.1,
      GlassTier.popup => 1.05,
    };
  }
}