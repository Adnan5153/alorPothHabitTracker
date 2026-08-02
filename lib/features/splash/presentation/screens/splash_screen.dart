import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/scaffold/liquid_scaffold/liquid_scaffold_exports.dart';
import '../widgets/loading_path_indicator.dart';
import '../widgets/logo_illustration.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.onComplete});

  final VoidCallback? onComplete;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const _ease = Curves.easeInOutCubic;

  static const double _glowStart = 0.10;
  static const double _glowEnd = 0.70;
  static const double _scaleStart = 0.20;
  static const double _scaleEnd = 0.75;
  static const double _titleStart = 0.70;
  static const double _titleEnd = 0.85;
  static const double _taglineStart = 0.80;
  static const double _taglineEnd = 0.95;

  late final AnimationController _timeline;
  late final Animation<double> _glow;
  late final Animation<double> _scale;
  late final Animation<double> _title;
  late final Animation<double> _tagline;

  @override
  void initState() {
    super.initState();
    _timeline = AnimationController(
      vsync: this,
      duration: AppSizes.splashDuration,
    );

    _glow = _stagger(_glowStart, _glowEnd);
    _scale = _stagger(_scaleStart, _scaleEnd);
    _title = _stagger(_titleStart, _titleEnd);
    _tagline = _stagger(_taglineStart, _taglineEnd);

    _timeline.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    _timeline.forward();
  }

  Animation<double> _stagger(double start, double end) => CurvedAnimation(
        parent: _timeline,
        curve: Interval(start, end, curve: _ease),
      );

  @override
  void dispose() {
    _timeline.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      child: LiquidScaffold(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.screenPaddingHorizontal,
        ),
        backgroundGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark ? AppColors.darkGradient : AppColors.skyGradient,
        ),
        body: Column(
          children: [
            const Spacer(flex: AppSizes.splashTopFlex),
            Expanded(
              flex: AppSizes.splashIllustrationFlex,
              child: _Illustration(
                glow: _glow,
                scale: _scale,
                isDark: isDark,
              ),
            ),
            const SizedBox(height: AppSizes.space12),
            Expanded(
              flex: AppSizes.splashBrandingFlex,
              child: _Branding(
                titleOpacity: _title,
                taglineOpacity: _tagline,
                isDark: isDark,
              ),
            ),
            Expanded(
              flex: AppSizes.splashBottomFlex,
              child: FadeTransition(
                opacity: _tagline,
                child: const LoadingPathIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Illustration extends StatelessWidget {
  const _Illustration({
    required this.glow,
    required this.scale,
    required this.isDark,
  });

  final Animation<double> glow;
  final Animation<double> scale;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([glow, scale]),
      builder: (context, _) => Center(
        child: LogoIllustration(
          glowProgress: glow.value,
          scaleProgress: scale.value,
          isDark: isDark,
        ),
      ),
    );
  }
}

class _Branding extends StatelessWidget {
  const _Branding({
    required this.titleOpacity,
    required this.taglineOpacity,
    required this.isDark,
  });

  final Animation<double> titleOpacity;
  final Animation<double> taglineOpacity;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([titleOpacity, taglineOpacity]),
      builder: (context, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: titleOpacity.value,
              child: Text(
                AppStrings.appName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppSizes.fontSizeTitle,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.titleDark : AppColors.titleLight,
                  letterSpacing: AppSizes.letterSpacingTitle,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.space8),
            Opacity(
              opacity: taglineOpacity.value,
              child: Text(
                AppStrings.tagline,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppSizes.fontSizeBody,
                  fontWeight: FontWeight.normal,
                  color: isDark ? AppColors.taglineDark : AppColors.taglineLight,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
