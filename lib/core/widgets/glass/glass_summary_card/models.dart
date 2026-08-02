import 'package:flutter/material.dart';

import '../glass_container/constants.dart';
import 'constants.dart';

/// Compile-time view-model for the [GlassSummaryCard] surface. Holds
/// every value scaled by [GlassSize] so the render body stays terse.
@immutable
class GlassSummaryCardMetrics {
  const GlassSummaryCardMetrics({
    required this.valueSize,
    required this.iconContainerSize,
    required this.iconSize,
    required this.padding,
  });

  factory GlassSummaryCardMetrics.of(GlassSize size) {
    return switch (size) {
      GlassSize.small => const GlassSummaryCardMetrics(
          valueSize: GlassSummaryCardConstants.valueSizeSmall,
          iconContainerSize: GlassSummaryCardConstants.iconContainerSizeSmall,
          iconSize: GlassSummaryCardConstants.iconSizeSmall,
          padding: EdgeInsets.all(GlassConstants.space12),
        ),
      GlassSize.medium => const GlassSummaryCardMetrics(
          valueSize: GlassSummaryCardConstants.valueSizeMedium,
          iconContainerSize: GlassSummaryCardConstants.iconContainerSizeMedium,
          iconSize: GlassSummaryCardConstants.iconSizeMedium,
          padding: EdgeInsets.all(GlassConstants.space16),
        ),
      GlassSize.large => const GlassSummaryCardMetrics(
          valueSize: GlassSummaryCardConstants.valueSizeLarge,
          iconContainerSize: GlassSummaryCardConstants.iconContainerSizeLarge,
          iconSize: GlassSummaryCardConstants.iconSizeLarge,
          padding: EdgeInsets.all(GlassConstants.space20),
        ),
    };
  }

  final double valueSize;
  final double iconContainerSize;
  final double iconSize;
  final EdgeInsetsGeometry padding;
}

/// Direction of a trend indicator (e.g. streak growth vs decline).
enum GlassTrend { up, down, flat }

extension GlassTrendVisual on GlassTrend {
  IconData get icon {
    return switch (this) {
      GlassTrend.up => Icons.trending_up_rounded,
      GlassTrend.down => Icons.trending_down_rounded,
      GlassTrend.flat => Icons.trending_flat_rounded,
    };
  }
}

/// Semantic tone for a status badge.
enum GlassStatusTone { neutral, positive, warning, negative }

extension GlassStatusToneColor on GlassStatusTone {
  Color foregroundOf(ColorScheme scheme) {
    return switch (this) {
      GlassStatusTone.neutral => scheme.onSurfaceVariant,
      GlassStatusTone.positive => scheme.tertiary,
      GlassStatusTone.warning => scheme.secondary,
      GlassStatusTone.negative => scheme.error,
    };
  }
}