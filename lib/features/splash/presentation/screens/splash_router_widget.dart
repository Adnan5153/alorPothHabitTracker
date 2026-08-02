import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../auth/presentation/viewmodels/auth_providers.dart';
import 'splash_screen.dart';

/// Bridges the splash timeline animation to the GoRouter. Once the
/// timeline completes the widget picks the appropriate destination
/// (onboarding when nobody is signed in, home otherwise) and pushes
/// it as a replacement. The widget defers navigation until the auth
/// controller has produced a first value so the router never flips
/// between splash and onboarding twice in a row.
class SplashRouterWidget extends ConsumerWidget {
  const SplashRouterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authControllerProvider, (previous, next) {
      if (next.isLoading || next.hasError) return;
      if (next.value == null) return;
      _navigate(context, ref);
    });

    return SplashScreen(
      onComplete: () {
        if (!context.mounted) return;
        final value = ref.read(authControllerProvider).value;
        if (value != null) {
          _navigate(context, ref);
        }
      },
    );
  }

  void _navigate(BuildContext context, WidgetRef ref) {
    if (!context.mounted) return;
    final auth = ref.read(authControllerProvider).value;
    if (auth == null) return;
    final destination =
        auth.isSignedIn ? AppRoutes.home : AppRoutes.onboarding;
    if (GoRouterState.of(context).uri.path != AppRoutes.splash) return;
    GoRouter.of(context).pushReplacement(destination);
  }
}
