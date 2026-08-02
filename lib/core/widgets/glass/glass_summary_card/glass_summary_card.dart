import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../liquidGlass/effects/liquid_glass_effect.dart';
import '../../../liquidGlass/theme/liquid_theme.dart';
import '../../../liquidGlass/transitions/liquid_transition.dart';
import '../glass_container/exports.dart';
import 'constants.dart';
import 'models.dart';

/// Liquid Glass dashboard surface for a value, label and optional supporting
/// content. Presentation-only: all data and actions are supplied by callers.
class GlassSummaryCard extends StatelessWidget {
  const GlassSummaryCard({
    super.key,
    required this.value,
    required this.label,
    this.formattedValue,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.progress,
    this.statusLabel,
    this.statusTone = GlassStatusTone.neutral,
    this.trend,
    this.trendValue,
    this.chart,
    this.size = GlassSize.medium,
    this.onTap,
    this.tier = GlassTier.standard,
    this.padding,
    this.margin,
    this.tint,
    this.animateValue = true,
  });

  final num value;
  final String label;
  final String? formattedValue;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final double? progress;
  final String? statusLabel;
  final GlassStatusTone statusTone;
  final GlassTrend? trend;
  final String? trendValue;
  final Widget? chart;
  final GlassSize size;
  final VoidCallback? onTap;
  final GlassTier tier;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? tint;
  final bool animateValue;

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size.forContext(context);
    final metrics = GlassSummaryCardMetrics.of(effectiveSize);
    final theme = LiquidThemes.of(context);
    final palette = GlassPalette.of(context);
    final accent = iconColor ?? palette.accent;
    final display = formattedValue ?? value.toString();

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (icon != null)
              _IconBadge(
                icon: icon!,
                color: accent,
                size: metrics.iconContainerSize,
                iconSize: metrics.iconSize,
              ),
            if (icon != null) const Spacer(),
            if (statusLabel != null)
              _StatusBadge(label: statusLabel!, tone: statusTone),
          ],
        ),
        const SizedBox(height: GlassSummaryCardConstants.labelGap),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textStyle.copyWith(
            fontSize: GlassSummaryCardConstants.labelSize,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
            color: palette.mutedForeground,
          ),
        ),
        const SizedBox(height: GlassSummaryCardConstants.valueGap),
        _AnimatedNumber(
          text: display,
          fontSize: metrics.valueSize,
          color: palette.foreground,
          enabled: animateValue,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: GlassSummaryCardConstants.subtitleGap),
          Text(
            subtitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textStyle.copyWith(
              fontSize: GlassSummaryCardConstants.subtitleSize,
              color: palette.mutedForeground,
            ),
          ),
        ],
        if (progress != null) ...[
          const SizedBox(height: GlassSummaryCardConstants.statusGap),
          _ProgressBar(value: progress!.clamp(0.0, 1.0), color: accent),
        ],
        if (trend != null) ...[
          const SizedBox(height: GlassSummaryCardConstants.statusGap),
          _TrendIndicator(trend: trend!, value: trendValue, accent: accent),
        ],
        if (chart != null) ...[
          const SizedBox(height: GlassSummaryCardConstants.chartGap),
          chart!,
        ],
      ],
    );

    final surface = LiquidGlassEffect(
      baseColor: tint ?? theme.surfaceTint,
      borderRadius: GlassSummaryCardConstants.cardRadius,
      borderColor: theme.borderColor,
      borderWidth: GlassSummaryCardConstants.borderWidth,
      margin: margin is EdgeInsets ? margin as EdgeInsets? : null,
      surfaceOpacity: theme.surfaceOpacity * _opacityForTier(tier),
      blurStrength: theme.blurStrength * _blurForTier(tier),
      reflectionIntensity: theme.reflectionIntensity,
      child: Padding(
        padding: padding ?? metrics.padding,
        child: content,
      ),
    );

    final interactive = onTap == null
        ? surface
        : LiquidPressController(
            enabled: true,
            child: (context, animation, _) => LiquidTransition(
              animation: animation,
              beginScale: GlassSummaryCardConstants.pressScale,
              fade: false,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(
                  GlassSummaryCardConstants.cardRadius,
                ),
                splashColor: theme.lightReflectionColor.withValues(alpha: 0.12),
                highlightColor:
                    theme.lightReflectionColor.withValues(alpha: 0.06),
                child: surface,
              ),
            ),
          );

    return Semantics(
      button: onTap != null,
      enabled: onTap != null,
      label: label,
      child: interactive,
    );
  }

  double _opacityForTier(GlassTier tier) => switch (tier) {
        GlassTier.subtle => 0.72,
        GlassTier.standard => 1.0,
        GlassTier.bold => 1.18,
        GlassTier.popup => 1.08,
      };

  double _blurForTier(GlassTier tier) => switch (tier) {
        GlassTier.subtle => 0.7,
        GlassTier.standard => 1.0,
        GlassTier.bold => 1.25,
        GlassTier.popup => 1.1,
      };
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.color,
    required this.size,
    required this.iconSize,
  });

  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = LiquidThemes.of(context);
    return SizedBox(
      width: size,
      height: size,
      child: Align(
        alignment: Alignment.center,
        child: LiquidGlassEffect(
          baseColor: color,
          borderColor: color,
          borderRadius: size / 3,
          borderWidth: GlassSummaryCardConstants.borderWidth,
          blurStrength: theme.blurStrength * 0.45,
          surfaceOpacity: theme.surfaceOpacity * 0.8,
          reflectionIntensity: theme.reflectionIntensity * 0.7,
          child: Icon(icon, size: iconSize, color: color),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.tone});

  final String label;
  final GlassStatusTone tone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = tone.foregroundOf(scheme);
    return Container(
      height: GlassSummaryCardConstants.badgeHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: GlassSummaryCardConstants.badgeHorizontalPadding,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: GlassSummaryCardConstants.badgeAlpha),
        borderRadius: BorderRadius.circular(GlassSummaryCardConstants.badgeRadius),
        border: Border.all(
          color: color.withValues(alpha: GlassSummaryCardConstants.badgeBorderAlpha),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: GlassSummaryCardConstants.badgeFontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = LiquidThemes.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(GlassSummaryCardConstants.progressHeight),
      child: LinearProgressIndicator(
        value: value,
        minHeight: GlassSummaryCardConstants.progressHeight,
        backgroundColor: color.withValues(
          alpha: theme.surfaceOpacity * GlassSummaryCardConstants.progressTrackAlpha,
        ),
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

class _TrendIndicator extends StatelessWidget {
  const _TrendIndicator({
    required this.trend,
    required this.value,
    required this.accent,
  });

  final GlassTrend trend;
  final String? value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = switch (trend) {
      GlassTrend.up => scheme.tertiary,
      GlassTrend.down => scheme.error,
      GlassTrend.flat => accent,
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          trend.icon,
          size: GlassSummaryCardConstants.trendIndicatorSize,
          color: color,
        ),
        const SizedBox(width: GlassSummaryCardConstants.trendIndicatorGap),
        if (value != null)
          Text(
            value!,
            style: TextStyle(
              color: color,
              fontSize: GlassSummaryCardConstants.subtitleSize,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}

class _AnimatedNumber extends StatelessWidget {
  const _AnimatedNumber({
    required this.text,
    required this.fontSize,
    required this.color,
    required this.enabled,
  });

  final String text;
  final double fontSize;
  final Color color;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      color: color,
      letterSpacing: -0.2,
    );
    final number = Text(
      text,
      key: ValueKey<String>(text),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
    if (!enabled) return number;
    return number
        .animate(key: ValueKey<String>('summary-number-$text'))
        .fadeIn(
          duration: GlassSummaryCardConstants.numberAnimation,
          curve: GlassSummaryCardConstants.numberCurve,
        )
        .moveY(
          begin: GlassSummaryCardConstants.numberMoveY,
          end: 0,
          duration: GlassSummaryCardConstants.numberAnimation,
          curve: GlassSummaryCardConstants.numberCurve,
        );
  }
}