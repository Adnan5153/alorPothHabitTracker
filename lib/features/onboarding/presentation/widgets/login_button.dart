import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/errors/error_messages.dart';
import '../../../../core/liquidGlass/effects/liquid_glass_effect.dart';
import '../../../../core/liquidGlass/theme/liquid_theme.dart';
import '../../../../core/liquidGlass/transitions/liquid_transition.dart';
import '../../../../core/widgets/button/button_extensions.dart';
import '../../../../core/widgets/button/button_sizes.dart';
import '../../../auth/presentation/viewmodels/auth_providers.dart';
import '../viewmodels/onboarding_viewmodel.dart';

/// Onboarding entry-point button. The widget owns presentation and delegates
/// the Google Sign-In flow to [OnboardingViewModel]. Cancellation remains a
/// silent no-op, while failures are surfaced through a SnackBar.
class LoginButton extends ConsumerWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(onboardingViewModelProvider);
    final auth = ref.watch(authControllerProvider);
    final isLoading = viewModel.isLoading || auth.isLoading;

    ref.listen(authControllerProvider, (previous, next) {
      final message = next.value?.errorMessage;
      if (message == null || message == previous?.value?.errorMessage) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    });

    return _LoginGlassSurface(
      isLoading: isLoading,
      onPressed: isLoading ? null : () => _handleSignIn(context, ref),
    );
  }

  Future<void> _handleSignIn(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final result = await ref
          .read(onboardingViewModelProvider)
          .signInWithGoogle();
      if (!context.mounted) return;
      if (result.isCancelled) return;
      if (result.isFailure) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(ErrorMessages.from(result.error!))),
          );
        return;
      }
      context.go(AppRoutes.home);
    } catch (error) {
      if (!context.mounted) return;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(ErrorMessages.from(error))));
    }
  }
}

class _LoginGlassSurface extends StatelessWidget {
  const _LoginGlassSurface({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final liquidTheme = LiquidThemes.of(context);
    final palette = liquidTheme.toButtonPalette(Theme.of(context).colorScheme);
    final metrics = ButtonMetrics.of(ButtonSize.medium.forContext(context));
    final disabled = isLoading || onPressed == null;
    final isDark = LiquidThemes.isDark(context);
    final foreground = disabled ? palette.disabled : palette.onAccent;
    final hairlineAlpha = disabled ? 0.18 : (isDark ? 0.30 : 0.45);

    final effect = LiquidGlassEffect(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      borderRadius: 96.0,
      borderWidth: 0.6,
      borderColor: Colors.white.withValues(alpha: hairlineAlpha),
      baseColor: liquidTheme.surfaceTint,
      blurStrength: liquidTheme.blurStrength,
      surfaceOpacity: disabled ? 0.18 : liquidTheme.surfaceOpacity,
      reflectionIntensity: disabled ? 0.18 : liquidTheme.reflectionIntensity,
      boxShadow: disabled
          ? null
          : const [
              BoxShadow(
                color: Color(0x2E000000),
                blurRadius: 28,
                offset: Offset(0, 12),
              ),
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: AppButtonSizes.minTouchTarget,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppButtonSizes.padH,
            vertical: metrics.verticalPadding,
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: LiquidMotion.micro,
              child: isLoading
                  ? _LoginSpinner(
                      key: const ValueKey('login-loading'),
                      foreground: foreground,
                    )
                  : _LoginLabel(
                      key: const ValueKey('login-label'),
                      foreground: foreground,
                    ),
            ),
          ),
        ),
      ),
    );

    return Semantics(
      label: AppStrings.loginButton,
      button: true,
      enabled: !disabled,
      child: IgnorePointer(
        ignoring: disabled,
        child: LiquidPressController(
          enabled: !disabled,
          onPressed: disabled ? null : onPressed,
          child: (_, animation, _) => LiquidTransition(
            animation: animation,
            beginScale: 0.985,
            fade: false,
            child: effect,
          ),
        ),
      ),
    );
  }
}

class _LoginLabel extends StatelessWidget {
  const _LoginLabel({super.key, required this.foreground});

  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _GoogleBrandMark(),
        const SizedBox(width: AppButtonSizes.iconLabelGap),
        Flexible(
          child: Text(
            AppStrings.loginButton,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: LiquidThemes.of(context).textStyle.copyWith(
              color: foreground,
              fontSize: AppButtonSizes.fontSizeMedium,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }
}

class _GoogleBrandMark extends StatelessWidget {
  const _GoogleBrandMark();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/google_g_logo.svg',
      width: AppButtonSizes.iconMedium + 4,
      height: AppButtonSizes.iconMedium + 4,
    );
  }
}

class _LoginSpinner extends StatelessWidget {
  const _LoginSpinner({super.key, required this.foreground});

  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppButtonSizes.loadingSize,
      height: AppButtonSizes.loadingSize,
      child: CircularProgressIndicator(
        strokeWidth: AppButtonSizes.loadingStroke,
        valueColor: AlwaysStoppedAnimation<Color>(foreground),
      ),
    );
  }
}
