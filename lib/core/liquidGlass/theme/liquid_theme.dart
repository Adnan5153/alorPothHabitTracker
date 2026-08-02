import 'package:flutter/material.dart';

class LiquidTheme {
  final Color primaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color lightReflectionColor;
  final double blurStrength;
  final double borderRadius;
  final TextStyle textStyle;
  final EdgeInsets defaultPadding;
  final EdgeInsets defaultMargin;

  /// Tint of the glass surface. Drives the `opacity` value of the
  /// blur container — low alpha in dark mode, higher in light mode.
  final Color surfaceTint;

  /// Border colour for the glass surface.
  final Color borderColor;

  /// 0.0 → 1.0; controls how visible the white reflection layer is.
  final double reflectionIntensity;

  /// 0.0 → 1.0; opacity of the surface tint layer above the blur.
  final double surfaceOpacity;

  /// Brightness this bundle was tuned for. Consumers that need
  /// brightness-aware defaults (e.g. reflection intensity) read this
  /// instead of poking at `Theme.of`.
  final Brightness brightness;

  const LiquidTheme({
    this.primaryColor = const Color(0xFFADB2E8),
    this.accentColor = const Color(0xFF98C9F1),
    this.backgroundColor = const Color(0xFF1F1F1F),
    this.lightReflectionColor = const Color(0x66FFFFFF),
    this.blurStrength = 20.0,
    this.borderRadius = 20.0,
    this.textStyle = const TextStyle(
      fontFamily: 'SFPro',
      color: Colors.white70,
      fontWeight: FontWeight.w500,
    ),
    this.defaultPadding = const EdgeInsets.all(16.0),
    this.defaultMargin = const EdgeInsets.symmetric(vertical: 8.0),
    this.surfaceTint = const Color(0xFFFFFFFF),
    this.borderColor = const Color(0xFFFFFFFF),
    this.reflectionIntensity = 0.8,
    this.surfaceOpacity = 0.68,
    this.brightness = Brightness.dark,
  });

  /// Adaptive factory: produces a dark- or light-tuned [LiquidTheme]
  /// using the active [ColorScheme]. Used by [LiquidThemes.of] when no
  /// provider is in scope so widgets always render against a bundle
  /// that matches the active [AppTheme] brightness.
  factory LiquidTheme.forBrightness(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return LiquidTheme(
      brightness: brightness,
      surfaceTint: isDark ? Colors.white : Colors.white,
      borderColor: isDark ? Colors.white : Colors.black,
      surfaceOpacity: isDark ? 0.10 : 0.55,
      reflectionIntensity: isDark ? 0.35 : 0.55,
      blurStrength: isDark ? 22.0 : 14.0,
      textStyle: TextStyle(
        fontFamily: 'SFPro',
        color: isDark ? Colors.white70 : const Color(0xFF0F172A),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// Derives a [LiquidTheme] from an active Material [ThemeData].
  /// Lets `AppTheme` ship a matching Liquid Glass bundle alongside its
  /// `ThemeData` so a single [AppTheme.light] / [AppTheme.dark] call
  /// produces both surfaces in lockstep.
  factory LiquidTheme.fromThemeData(ThemeData theme) {
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final base = LiquidTheme.forBrightness(theme.brightness);
    return LiquidTheme(
      brightness: theme.brightness,
      primaryColor: scheme.primary,
      accentColor: scheme.primary,
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTint: scheme.surface,
      borderColor: scheme.outline,
      surfaceOpacity: base.surfaceOpacity,
      reflectionIntensity: base.reflectionIntensity,
      blurStrength: base.blurStrength,
      textStyle: (theme.textTheme.bodyMedium ??
              const TextStyle(fontWeight: FontWeight.w500))
          .copyWith(color: scheme.onSurface),
    );
  }

  /// Adaptive button palette. Pulls `accent` / `onAccent` / disabled tints
  /// from the active [ColorScheme] so the button family can read a single
  /// bundle instead of poking at `Theme.of` at every call site.
  ButtonPalette toButtonPalette(ColorScheme scheme) {
    return ButtonPalette(
      accent: accentColor,
      onAccent: scheme.onPrimary,
      disabled: scheme.onSurface.withValues(alpha: 0.38),
      disabledSurface: scheme.onSurface.withValues(alpha: 0.10),
      border: scheme.outline,
      reflection: lightReflectionColor,
    );
  }

  ThemeData toThemeData() {
    return ThemeData(
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentColor,
        brightness: brightness,
      ),
      textTheme: TextTheme(
        bodyMedium: textStyle,
        labelLarge: textStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class LiquidThemeProvider extends InheritedWidget {
  final LiquidTheme theme;

  const LiquidThemeProvider({
    super.key,
    required this.theme,
    required super.child,
  });

  static LiquidThemeProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LiquidThemeProvider>();
  }

  @override
  bool updateShouldNotify(LiquidThemeProvider oldWidget) =>
      theme != oldWidget.theme;
}

/// Convenience accessors so call sites can grab the right [LiquidTheme]
/// without juggling provider lookups.
class LiquidThemes {
  LiquidThemes._();

  /// Returns the bundle registered via [LiquidThemeProvider] when one
  /// is present in the widget tree. Otherwise derives a brightness-
  /// matched bundle from the active [Theme.of] so widgets always see
  /// a palette that complements [AppTheme.light] / [AppTheme.dark].
  static LiquidTheme of(BuildContext context) {
    final provider = LiquidThemeProvider.of(context);
    if (provider != null) return provider.theme;
    final brightness = Theme.of(context).brightness;
    return LiquidTheme.forBrightness(brightness);
  }

  /// Returns `true` when the active theme is dark.
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
}

/// Pre-resolved button palette sourced from [LiquidTheme]. Every
/// interactive button in the design system consumes this bundle so a
/// single design-token swap re-skins the entire family.
@immutable
class ButtonPalette {
  const ButtonPalette({
    required this.accent,
    required this.onAccent,
    required this.disabled,
    required this.disabledSurface,
    required this.border,
    required this.reflection,
  });

  final Color accent;
  final Color onAccent;
  final Color disabled;
  final Color disabledSurface;
  final Color border;
  final Color reflection;
}