import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/viewmodels/auth_providers.dart';

/// ViewModel for the splash feature. Determines the next route once the
/// splash timeline finishes — either onboarding (signed out) or home
/// (signed in).
class SplashViewModel {
  SplashViewModel(this._ref);

  final Ref _ref;

  /// Whether the current user is signed in according to the auth
  /// controller. Returns `false` while the AsyncNotifier is still warming
  /// up so the splash screen never flashes home for a signed-out user.
  bool get isSignedIn {
    final auth = _ref.read(authControllerProvider).value;
    return auth?.isSignedIn ?? false;
  }

  /// The duration the splash screen should stay on screen. Mirrors
  /// [AppSizes.splashDuration] so the VM and the presentation stay in
  /// sync.
  Duration get splashDuration => const Duration(milliseconds: 3000);
}

/// Provider exposing the [SplashViewModel] to the widget tree.
final splashViewModelProvider = Provider<SplashViewModel>(
  SplashViewModel.new,
);
