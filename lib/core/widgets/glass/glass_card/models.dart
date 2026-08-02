import 'package:flutter/material.dart';

import '../glass_container/constants.dart';
import 'constants.dart';

/// Compile-time view-model for [GlassCard]. Maps a [GlassSize] to the
/// padding, radius and title typography used by the body.
@immutable
class GlassCardMetrics {
  const GlassCardMetrics({
    required this.titleSize,
    required this.padding,
    required this.borderRadius,
  });

  factory GlassCardMetrics.of(GlassSize size) {
    return switch (size) {
      GlassSize.small => const GlassCardMetrics(
          titleSize: GlassCardConstants.titleSizeSmall,
          padding: EdgeInsets.all(GlassConstants.space12),
          borderRadius:
              BorderRadius.all(Radius.circular(GlassConstants.radiusSm)),
        ),
      GlassSize.medium => const GlassCardMetrics(
          titleSize: GlassCardConstants.titleSizeMedium,
          padding: EdgeInsets.all(GlassConstants.space16),
          borderRadius:
              BorderRadius.all(Radius.circular(GlassConstants.radiusMd)),
        ),
      GlassSize.large => const GlassCardMetrics(
          titleSize: GlassCardConstants.titleSizeLarge,
          padding: EdgeInsets.all(GlassConstants.space20),
          borderRadius:
              BorderRadius.all(Radius.circular(GlassConstants.radiusLg)),
        ),
    };
  }

  final double titleSize;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
}

/// Visual / behavioural state of [GlassCard].
enum GlassCardState { idle, hover, pressed, selected, disabled }

extension GlassCardStateHelpers on GlassCardState {
  bool get isInteractive =>
      this == GlassCardState.idle || this == GlassCardState.hover;

  double get scale {
    switch (this) {
      case GlassCardState.pressed:
        return GlassCardConstants.pressScale;
      case GlassCardState.idle:
      case GlassCardState.hover:
      case GlassCardState.selected:
      case GlassCardState.disabled:
        return 1.0;
    }
  }
}