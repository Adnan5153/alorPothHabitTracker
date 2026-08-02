import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';
import '../constants/app_sizes.dart';
import '../../features/auth/presentation/viewmodels/auth_providers.dart';
import '../../features/dashboard/presentation/screens/home_dashboard_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/splash/presentation/screens/splash_router_widget.dart';

const Duration _kFadeDuration = AppSizes.splashExitDuration;

final routerProvider = Provider<GoRouter>((ref) {
  final state = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: _AuthRefresh(ref),
    redirect: (context, routerState) {
      final location = routerState.uri.path;
      final auth = state.value;

      if (auth == null) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      switch (location) {
        case AppRoutes.splash:
          return auth.isSignedIn ? AppRoutes.home : AppRoutes.onboarding;
        case AppRoutes.home:
          return auth.isSignedIn ? null : AppRoutes.onboarding;
        case AppRoutes.onboarding:
          return auth.isSignedIn ? AppRoutes.home : null;
        default:
          return null;
      }
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SplashRouterWidget(),
        ),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        pageBuilder: (context, state) => _fadePage(
          key: state.pageKey,
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => _fadePage(
          key: state.pageKey,
          child: const HomeDashboardScreen(),
        ),
      ),
    ],
  );
});

CustomTransitionPage<void> _fadePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    transitionDuration: _kFadeDuration,
    reverseTransitionDuration: _kFadeDuration,
    child: child.animate().fadeIn(
          duration: _kFadeDuration,
          curve: Curves.easeInOutCubic,
        ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh(Ref ref) {
    ref.listen(authControllerProvider, (_, _) => notifyListeners());
  }
}