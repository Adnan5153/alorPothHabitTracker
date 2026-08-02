import 'package:flutter/material.dart';

import 'constants.dart';

/// Pre-resolved colour bundle for any glass surface. Snapshots the active
/// theme once per build so children can render without repeated lookups.
@immutable
class GlassPalette {
  const GlassPalette({
    required this.tint,
    required this.border,
    required this.shadow,
    required this.foreground,
    required this.mutedForeground,
    required this.accent,
    required this.onAccent,
    required this.disabled,
  });

  factory GlassPalette.of(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;
    final tintAlpha =
        isDark ? GlassConstants.tintAlphaDark : GlassConstants.tintAlphaLight;
    final borderAlpha =
        isDark ? GlassConstants.borderAlphaDark : GlassConstants.borderAlphaLight;
    final shadowAlpha =
        isDark ? GlassConstants.shadowAlphaDark : GlassConstants.shadowAlphaLight;
    return GlassPalette(
      tint: scheme.surface.withValues(alpha: tintAlpha),
      border: scheme.onSurface.withValues(alpha: borderAlpha),
      shadow: scheme.shadow.withValues(alpha: shadowAlpha),
      foreground: scheme.onSurface,
      mutedForeground: scheme.onSurfaceVariant,
      accent: scheme.primary,
      onAccent: scheme.onPrimary,
      disabled: scheme.onSurface.withValues(alpha: 0.38),
    );
  }

  final Color tint;
  final Color border;
  final Color shadow;
  final Color foreground;
  final Color mutedForeground;
  final Color accent;
  final Color onAccent;
  final Color disabled;

  GlassPalette copyWith({
    Color? tint,
    Color? border,
    Color? shadow,
    Color? foreground,
    Color? mutedForeground,
    Color? accent,
    Color? onAccent,
    Color? disabled,
  }) {
    return GlassPalette(
      tint: tint ?? this.tint,
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
      foreground: foreground ?? this.foreground,
      mutedForeground: mutedForeground ?? this.mutedForeground,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      disabled: disabled ?? this.disabled,
    );
  }
}

/// Per-size padding, radius, blur and elevation multipliers that drive the
/// Liquid Glass container. Values resolve from [GlassConstants] so any
/// future token update propagates everywhere.
@immutable
class GlassMetrics {
  const GlassMetrics({
    required this.padding,
    required this.borderRadius,
    required this.borderWidth,
    required this.shadowBlur,
    required this.blur,
  });

  factory GlassMetrics.of(GlassSize size) {
    return switch (size) {
      GlassSize.small => const GlassMetrics(
          padding: EdgeInsets.all(12),
          borderRadius:
              BorderRadius.all(Radius.circular(GlassConstants.radiusSm)),
          borderWidth: GlassConstants.borderThin,
          shadowBlur: GlassConstants.shadowBlurSmall,
          blur: GlassConstants.blurLight,
        ),
      GlassSize.medium => const GlassMetrics(
          padding: EdgeInsets.all(16),
          borderRadius:
              BorderRadius.all(Radius.circular(GlassConstants.radiusMd)),
          borderWidth: GlassConstants.borderStandard,
          shadowBlur: GlassConstants.shadowBlurMedium,
          blur: GlassConstants.blurStandard,
        ),
      GlassSize.large => const GlassMetrics(
          padding: EdgeInsets.all(24),
          borderRadius:
              BorderRadius.all(Radius.circular(GlassConstants.radiusLg)),
          borderWidth: GlassConstants.borderStandard,
          shadowBlur: GlassConstants.shadowBlurLarge,
          blur: GlassConstants.blurHeavy,
        ),
    };
  }

  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final double borderWidth;
  final double shadowBlur;
  final double blur;
}

/// Visual emphasis bands for any glass surface.
enum GlassTier { subtle, standard, bold, popup }