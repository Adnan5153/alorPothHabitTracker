import 'package:flutter/material.dart';

import '../glass_container/constants.dart';
import 'constants.dart';

/// Compile-time view-model for the [GlassPrimaryButton] surface. Each
/// variant resolves to a metrics bundle so the body renders identically
/// across the application.
@immutable
class GlassPrimaryButtonMetrics {
  const GlassPrimaryButtonMetrics({
    required this.verticalPadding,
    required this.iconSize,
  });

  factory GlassPrimaryButtonMetrics.of(GlassSize size) {
    return switch (size) {
      GlassSize.small => const GlassPrimaryButtonMetrics(
          verticalPadding: GlassPrimaryButtonConstants.padVSmall,
          iconSize: GlassPrimaryButtonConstants.iconSmall,
        ),
      GlassSize.medium => const GlassPrimaryButtonMetrics(
          verticalPadding: GlassPrimaryButtonConstants.padVMedium,
          iconSize: GlassPrimaryButtonConstants.iconMedium,
        ),
      GlassSize.large => const GlassPrimaryButtonMetrics(
          verticalPadding: GlassPrimaryButtonConstants.padVLarge,
          iconSize: GlassPrimaryButtonConstants.iconLarge,
        ),
    };
  }

  final double verticalPadding;
  final double iconSize;
}