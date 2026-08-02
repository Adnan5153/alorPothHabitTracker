import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/scaffold/liquid_scaffold/liquid_scaffold_exports.dart';
import '../widgets/login_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LiquidScaffold(
      padding: EdgeInsets.zero,
      entranceAnimation: true,
      ambient: const AmbientBackgroundStyle(enabled: true),
      backgroundGradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark ? AppColors.darkGradient : AppColors.skyGradient,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.screenPaddingHorizontal,
                  vertical: AppSizes.screenPaddingVertical,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    Text(
                      AppStrings.onboardingTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppSizes.fontSizeOnboardingTitle,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.titleDark
                            : AppColors.hillsPalette[2],
                      ),
                    ),
                    const SizedBox(height: AppSizes.space12),
                    const Text(
                      AppStrings.onboardingSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: AppSizes.fontSizeBody),
                    ),
                    const Spacer(),
                    const LoginButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
