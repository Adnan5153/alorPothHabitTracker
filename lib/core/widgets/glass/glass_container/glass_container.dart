import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../liquidGlass/effects/liquid_glass_effect.dart';
import '../../../liquidGlass/transitions/liquid_transition.dart';
import '../../../liquidGlass/theme/liquid_theme.dart';
import 'constants.dart';
import 'extensions.dart';
import 'models.dart';

/// Foundation Liquid Glass surface. Delegates rendering to the project's
/// Liquid Glass abstraction layer so the `liquid_glass_ui` package
/// remains an internal implementation detail.
class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    this.child,
    this.size = GlassSize.medium,
    this.tier = GlassTier.standard,
    this.blur,
    this.tint,
    this.gradient,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.constraints,
    this.alignment,
    this.shadow,
    this.shape = BoxShape.rectangle,
    this.animated = true,
    this.onTap,
    this.onLongPress,
    this.borderOnForeground = true,
  });

  final Widget? child;
  final GlassSize size;
  final GlassTier tier;

  final double? blur;
  final Color? tint;
  final Gradient? gradient;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final double? width;
  final BoxConstraints? constraints;
  final AlignmentGeometry? alignment;
  final List<BoxShadow>? shadow;
  final BoxShape shape;
  final bool animated;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool borderOnForeground;

  @override
  Widget build(BuildContext context) {
    final theme = LiquidThemes.of(context);
    final metrics = GlassMetrics.of(size.forContext(context));
    final effectiveBlur = (blur ?? metrics.blur) * tier.blurMultiplier;
    final effectiveRadius = shape == BoxShape.rectangle
        ? (borderRadius ?? metrics.borderRadius)
        : null;
    final defaultShadow = shape == BoxShape.rectangle
        ? [
            BoxShadow(
              color: (borderColor ?? theme.borderColor)
                  .withValues(alpha: 0.10 * tier.shadowMultiplier),
              blurRadius: metrics.shadowBlur,
              offset: const Offset(0, 6),
            ),
          ]
        : null;
    final resolvedShadow = shadow ?? defaultShadow;

    final core = LiquidGlassEffect(
      blurStrength: effectiveBlur,
      baseColor: tint,
      borderColor: borderColor,
      borderWidth: borderWidth ?? metrics.borderWidth,
      borderRadius: effectiveRadius?.topLeft.x ?? metrics.borderRadius.topLeft.x,
      padding: padding is EdgeInsets ? padding as EdgeInsets? : null,
      margin: margin is EdgeInsets ? margin as EdgeInsets? : null,
      surfaceOpacity: theme.surfaceOpacity * tier.opacityMultiplier,
      reflectionIntensity: theme.reflectionIntensity * tier.borderMultiplier,
      boxShadow: resolvedShadow,
      child: _Body(
        padding: padding,
        child: child,
      ),
    );

    Widget wrapped = core;
    if (width != null || height != null) {
      wrapped = SizedBox(width: width, height: height, child: wrapped);
    }
    if (constraints != null) {
      wrapped = ConstrainedBox(constraints: constraints!, child: wrapped);
    }
    if (alignment != null) {
      wrapped = Align(alignment: alignment!, child: wrapped);
    }

    final interactive = (onTap == null && onLongPress == null)
        ? wrapped
        : LiquidPressController(
            enabled: true,
            child: (context, animation, _) => LiquidTransition(
              animation: animation,
              beginScale: 0.985,
              fade: false,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: onTap,
                  onLongPress: onLongPress,
                  borderRadius: effectiveRadius,
                  splashColor: Colors.white.withValues(alpha: 0.06),
                  highlightColor: Colors.white.withValues(alpha: 0.04),
                  child: wrapped,
                ),
              ),
            ),
          );

    if (!animated) return interactive;
    return LiquidGlassEntrance(child: interactive);
  }
}

/// Entrance micro-animation used by [GlassContainer]. Lets the surface
/// fade into the tree without coupling every host to flutter_animate.
class LiquidGlassEntrance extends StatelessWidget {
  const LiquidGlassEntrance({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child
        .animate()
        .fadeIn(
          duration: GlassConstants.animStandard,
          curve: GlassConstants.animCurve,
        )
        .scale(
          begin: const Offset(0.985, 0.985),
          end: const Offset(1, 1),
          duration: GlassConstants.animStandard,
          curve: GlassConstants.animCurve,
        );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.padding, required this.child});

  final EdgeInsetsGeometry? padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final resolved = child ?? const SizedBox.shrink();
    if (padding == null) return resolved;
    return Padding(padding: padding!, child: resolved);
  }
}