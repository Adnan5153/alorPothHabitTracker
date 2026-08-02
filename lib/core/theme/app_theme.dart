import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../liquidGlass/theme/liquid_theme.dart';

/// Top-level theme entry point. Returns the [ThemeData] matching the
/// active [Brightness] — light via [LightAppTheme], dark via
/// [DarkAppTheme]. Use [AppTheme.light] / [AppTheme.dark] when an
/// explicit mode is needed (preview tooling, screenshot tests).
class AppTheme {
  AppTheme._();

  static const String _fontFamily = 'NotoSansBengali';

  static ThemeData get light => LightAppTheme.build();
  static ThemeData get dark => DarkAppTheme.build();

  /// Liquid Glass bundle tuned for the light [AppTheme]. Drop it in a
  /// [LiquidThemeProvider] right above [MaterialApp] so widgets that
  /// call `LiquidThemes.of(context)` see the same accent / surface
  /// tokens as the Material theme.
  static LiquidTheme get lightLiquidTheme => LiquidTheme.fromThemeData(light);

  /// Liquid Glass bundle tuned for the dark [AppTheme].
  static LiquidTheme get darkLiquidTheme => LiquidTheme.fromThemeData(dark);

  /// Resolves the Liquid Glass bundle matching [brightness].
  static LiquidTheme liquidThemeFor(Brightness brightness) =>
      LiquidTheme.fromThemeData(forBrightness(brightness));

  /// Builds a [ThemeData] for [brightness] by delegating to the
  /// dedicated light/dark configurations. Prefer [AppTheme.light] /
  /// [AppTheme.dark] over calling this directly.
  static ThemeData forBrightness(Brightness brightness) {
    return brightness == Brightness.dark
        ? DarkAppTheme.build()
        : LightAppTheme.build();
  }
}

/// Light-mode theme configuration. Owns every colour and surface
/// decision for the light theme — Material 3 seed, background, text
/// palette, and AppBar / FilledButton styling — so [AppTheme.light]
/// has a single, declarative source of truth.
class LightAppTheme {
  LightAppTheme._();

  static const Color _seed = AppColors.accent;
  static const Color _title = AppColors.titleLight;
  static const Color _tagline = AppColors.taglineLight;

  static ThemeData build() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
    );

    final textTheme = _textTheme(
      title: _title,
      tagline: _tagline,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.skyGradient.last,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        centerTitle: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _seed,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: AppSizes.space16),
          textStyle: const TextStyle(fontSize: AppSizes.fontSizeBody),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[
        AppTextColors(title: _title, tagline: _tagline),
      ],
    );
  }
}

/// Dark-mode theme configuration. Mirror of [LightAppTheme] but with
/// the dark gradient background and Bengali night-mode text palette.
class DarkAppTheme {
  DarkAppTheme._();

  static const Color _seed = AppColors.accent;
  static const Color _title = AppColors.titleDark;
  static const Color _tagline = AppColors.taglineDark;

  static ThemeData build() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    );

    final textTheme = _textTheme(
      title: _title,
      tagline: _tagline,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.darkGradient.first,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        centerTitle: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _seed,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: AppSizes.space16),
          textStyle: const TextStyle(fontSize: AppSizes.fontSizeBody),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[
        AppTextColors(title: _title, tagline: _tagline),
      ],
    );
  }
}

/// Shared text-theme construction. The dark and light themes only
/// differ in colour tokens, so the actual typography rules live here
/// once and are tinted per mode.
TextTheme _textTheme({required Color title, required Color tagline}) {
  return TextTheme(
    displaySmall: TextStyle(
      fontSize: AppSizes.fontSizeTitle,
      fontWeight: FontWeight.bold,
      letterSpacing: AppSizes.letterSpacingTitle,
    ),
    bodyLarge: TextStyle(
      fontSize: AppSizes.fontSizeBody,
      fontWeight: FontWeight.normal,
    ),
    headlineMedium: TextStyle(
      fontSize: AppSizes.fontSizeOnboardingTitle,
      fontWeight: FontWeight.bold,
    ),
  ).apply(
    bodyColor: tagline,
    displayColor: title,
    fontFamily: AppTheme._fontFamily,
  );
}

class AppTextColors extends ThemeExtension<AppTextColors> {
  const AppTextColors({required this.title, required this.tagline});

  final Color title;
  final Color tagline;

  @override
  AppTextColors copyWith({Color? title, Color? tagline}) => AppTextColors(
    title: title ?? this.title,
    tagline: tagline ?? this.tagline,
  );

  @override
  AppTextColors lerp(ThemeExtension<AppTextColors>? other, double t) {
    if (other is! AppTextColors) return this;
    return AppTextColors(
      title: Color.lerp(title, other.title, t)!,
      tagline: Color.lerp(tagline, other.tagline, t)!,
    );
  }
}

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle splashTitle = TextStyle(
    fontSize: AppSizes.fontSizeTitle,
    fontWeight: FontWeight.bold,
    letterSpacing: AppSizes.letterSpacingTitle,
  );

  static const TextStyle splashTagline = TextStyle(
    fontSize: AppSizes.fontSizeBody,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle onboardingTitle = TextStyle(
    fontSize: AppSizes.fontSizeOnboardingTitle,
    fontWeight: FontWeight.bold,
  );
}
