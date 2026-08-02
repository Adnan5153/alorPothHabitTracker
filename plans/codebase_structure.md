# Codebase Structure

## Root
```
alor_poth/
├── analysis_options.yaml
├── pubspec.yaml
├── pubspec.lock
├── android/
├── ios/
├── linux/
├── macos/
├── web/
├── windows/
├── assets/
│   ├── icon/
│   └── images/
├── lib/
└── test/
```

## lib/

### main.dart
- `main.dart`
  - `AlorPothApp` — root `MaterialApp.router`; wires `AppTheme.light` / `AppTheme.dark`, `ThemeMode.system`, `LiquidThemeProvider`, and `routerProvider`.

### lib/core/

#### lib/core/constants/
- `app_colors.dart` — brand palette: sun, path, sky gradient, hills palette, plant green, accent, dark gradient, title/tagline text colors.
- `app_radius.dart` — `AppRadius` radius scale (xs, sm, md, lg, xl, pill) + component tokens (button, card, chip).
- `app_sizes.dart` — `AppSizes`: spacing scale (4-pt grid), screen padding, splash flex weights, splash visuals, animation timing, typography sizes/letter spacing, illustration painter coordinates, sun/path/star/cloud constants, horizon glow.
- `app_strings.dart` — `AppStrings`: `appName`, `tagline`, `onboardingTitle`, `onboardingSubtitle`, `loginButton`.

#### lib/core/theme/
- `app_theme.dart` — `AppTheme`: Material 3 light + dark; `ColorScheme.fromSeed(AppColors.accent)`; Bengali font family, `AppBarTheme`, `FilledButtonThemeData`, `AppTextColors` theme extension, and `AppTextStyles`.

#### lib/core/widgets/

##### lib/core/widgets/appbar/
- `custom_app_bar.dart` — `CustomAppBar` fixed toolbar (`PreferredSizeWidget`). Supports title/subtitle, leading, actions, centerTitle, gradient/transparent/shadow, avatar, search, notification, theme toggle, Hero-tag, animated appearance.
- `custom_sliver_app_bar.dart` — `CustomSliverAppBar`. Pinned/floating/snap/stretch, large title, gradient + background image + flex space, collapsing animation, parallax.
- `app_bar_title.dart` — `AppBarTitle`, `AppBarSubtitle`, `AppBarLargeTitle`.
- `app_bar_back_button.dart` — adaptive `AppBarBackButton`; root-navigator aware.
- `app_bar_action_button.dart` — generic `AppBarActionButton` (icon, tooltip, color) with min tap-target.
- `app_bar_avatar.dart` — `AppBarAvatar` circular avatar w/ Hero + fallback icon.
- `app_bar_search_button.dart` — `AppBarSearchButton` with active-state highlight.
- `app_bar_notification_button.dart` — `AppBarNotificationButton` with unread badge.
- `app_bar_theme_button.dart` — `AppBarThemeButton` light/dark/system cycle.
- `app_bar_constants.dart` — `AppBarSizes` (toolbar heights, breakpoints, fonts, badge sizes) + `AppBarDurations`.
- `app_bar_extensions.dart` — `AppBarVariant` enum + `AppBarVariantPreset` behavioural presets + `AppBarResponsive` extension on `BuildContext` + `AppBarColors` scheme lookups.
- `app_bar_colors_runtime.dart` — `AppBarColorsRuntime` immutable pre-resolved colour bundle (foreground, background, muted, surfaceTint, primary, onPrimary, titleStyle).
- `app_bar_preview_page.dart` — `AppBarPreviewPage` visual catalogue + `AppBarPreviewRegistrar` (Widget Builder hook: `registeredVariants`, `variantLabels`, `build(variant)`).

##### lib/core/widgets/scaffold/
- `liquid_scaffold/` — canonical page container and public barrel; composes the background, Material chrome passthrough, body, overlays, loading state, and optional app bar/navigation slots.
- `liquid_background/` — theme-backed solid/gradient/image background plus optional slow ambient lighting painter.
- `liquid_body/` — SafeArea, token-based padding, optional scrolling, and optional page entrance animation.
- `liquid_overlay/` — positioned overlay and centered LiquidGlassEffect loading chrome with optional scrim.
- `liquid_safe_area/` — transparent SafeArea wrapper with independently configurable edges.
- `liquid_scaffold_theme/` — `LiquidScaffoldThemeData` tokens and inherited access widget.
- `liquid_scaffold_extensions/` — `BuildContext` accessors for scaffold theme tokens.

Rule: feature screens use `LiquidScaffold` rather than raw `Scaffold`; scaffold files contain presentation/layout composition only and no business logic.

### lib/features/

#### lib/features/splash/
- `presentation/screens/splash_screen.dart` — `SplashScreen` with timeline-driven glow/scale/title/tagline animations; uses `LiquidScaffold`.
- `presentation/widgets/loading_path_indicator.dart` — `LoadingPathIndicator` placeholder widget.
- `presentation/widgets/logo_illustration.dart` — `LogoIllustration` painter rendering sun, path, hills, plant, stars, clouds.

#### lib/features/onboarding/
- `presentation/screens/onboarding_screen.dart` — `OnboardingScreen` centered title, subtitle, and `LoginButton` inside `LiquidScaffold`.
- `presentation/widgets/login_button.dart` — `LoginButton` using the Liquid Glass interaction surface and `LiquidPressController`.

#### lib/features/dashboard/
- `presentation/screens/home_dashboard_screen.dart` — `HomeDashboardScreen` with dashboard `CustomAppBar` and LiquidScaffold content.

## test/
- `widget_test.dart` — basic widget test asserting splash branding text renders.

## Feature→AppBar mapping (planned/integrated)
| Feature | AppBar Component | Variant |
|---|---|---|
| Splash | none | — |
| Onboarding | none | — |
| Dashboard | `CustomAppBar` / `CustomSliverAppBar` | `dashboard` |
| Profile | `CustomAppBar` / `CustomSliverAppBar` | `profile` |
| Search | `CustomSliverAppBar` | `search` |
| Settings | `CustomAppBar` | `settings` |
| Details | `CustomSliverAppBar` | `details` |
| AI Screen | `CustomAppBar` | `ai` |
| Statistics | `CustomSliverAppBar` | `statistics` |
| Calendar | `CustomAppBar` | `calendar` |
| Leaderboard | `CustomAppBar` | `leaderboard` |
| Preview/Catalog | `AppBarPreviewPage` | all variants |
