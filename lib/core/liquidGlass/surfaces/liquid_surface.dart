import 'package:flutter/material.dart';
import 'package:liquid_glass_ui/liquid_glass_ui.dart';

import '../theme/liquid_theme.dart';

/// Centralised Liquid Glass surface used by every chrome component
/// (AppBar buttons, avatars, action chips). The wrapper resolves an
/// adaptive palette via [LiquidThemes.of] and forwards the rendered
/// child through [LiquidGlassContainer] from the `liquid_glass_ui`
/// package.
///
/// Why this helper exists: the package's `LiquidGlassContainer` only
/// exposes blur, opacity, padding and border radius. Every chrome
/// element needs the same adaptive opacity / border treatment, so we
/// resolve those defaults here once instead of re-deriving them at
/// every call site. The helper also enforces a 48dp minimum touch
/// target so accessibility guidelines stay satisfied.
class LiquidSurface extends StatelessWidget {
  const LiquidSurface({
    super.key,
    required this.child,
    this.blur,
    this.opacity,
    this.padding,
    this.borderRadius,
    this.minTouchTarget = true,
    this.borderOnForeground = true,
    this.borderWidth = 0.6,
  });

  /// Optional child override. When null, an empty SizedBox is rendered
  /// — keeping the surface reservation intact.
  final Widget child;

  /// Override for the backdrop blur sigma. Defaults to the theme's
  /// `blurStrength` which is adaptive for light/dark.
  final double? blur;

  /// Override for the surface tint opacity (0.0 → 1.0). When null the
  /// surface uses [LiquidTheme.surfaceOpacity] from the active bundle.
  final double? opacity;

  /// Inner padding around the child. When null the surface uses no
  /// padding — callers compose their own layout.
  final EdgeInsetsGeometry? padding;

  /// Override for the border radius. Defaults to 12dp for action
  /// buttons, larger surfaces pass their own.
  final BorderRadiusGeometry? borderRadius;

  /// When true (default) the surface enforces a 48dp minimum touch
  /// target via [SizedBox] constraints so accessibility guidelines are
  /// never violated by an over-aggressive caller.
  final bool minTouchTarget;

  /// When true, draws a hairline border around the surface for an
  /// extra-crisp glass edge in light themes.
  final bool borderOnForeground;

  /// Width of the hairline border (only used when
  /// [borderOnForeground] is true).
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final theme = LiquidThemes.of(context);
    final isDark = LiquidThemes.isDark(context);
    final effectiveRadius = borderRadius ?? BorderRadius.circular(12);
    final effectiveBlur = blur ?? theme.blurStrength;
    final effectiveOpacity = opacity ?? theme.surfaceOpacity;

    Widget content = LiquidGlassContainer(
      blur: effectiveBlur,
      opacity: effectiveOpacity,
      padding: padding,
      borderRadius: effectiveRadius,
      child: child,
    );

    if (borderOnForeground) {
      content = Container(
        decoration: BoxDecoration(
          borderRadius: effectiveRadius,
          border: Border.all(
            color: theme.borderColor.withValues(alpha: isDark ? 0.18 : 0.30),
            width: borderWidth,
          ),
        ),
        child: content,
      );
    }

    if (minTouchTarget) {
      content = ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 48,
        ),
        child: content,
      );
    }

    return content;
  }
}

/// Ink-tap shell that wraps a [LiquidSurface] with a `Material` +
/// `InkWell` so tap targets produce a ripple on the glass without
/// dimming the surface. Shared by every tappable AppBar chrome piece
/// (back, search, notification, theme, avatar).
class LiquidTapSurface extends StatelessWidget {
  const LiquidTapSurface({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.semanticLabel,
    this.tooltip,
    this.borderRadius,
    this.padding,
    this.borderOnForeground = true,
    this.borderWidth = 0.6,
    this.minTouchTarget = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? semanticLabel;
  final String? tooltip;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool borderOnForeground;
  final double borderWidth;
  final bool minTouchTarget;

  @override
  Widget build(BuildContext context) {
    final theme = LiquidThemes.of(context);
    final radius = (borderRadius ?? BorderRadius.circular(12)) as BorderRadius;

    Widget core = LiquidSurface(
      borderRadius: radius,
      padding: padding,
      borderOnForeground: borderOnForeground,
      borderWidth: borderWidth,
      minTouchTarget: minTouchTarget,
      child: child,
    );

    core = Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: radius,
        splashColor: theme.lightReflectionColor.withValues(alpha: 0.20),
        highlightColor: theme.lightReflectionColor.withValues(alpha: 0.10),
        child: core,
      ),
    );

    if (semanticLabel != null) {
      core = Semantics(
        label: semanticLabel,
        button: onTap != null || onLongPress != null,
        child: core,
      );
    }

    if (tooltip != null) {
      core = Tooltip(message: tooltip!, child: core);
    }

    return core;
  }
}