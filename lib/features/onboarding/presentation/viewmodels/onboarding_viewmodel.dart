import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/usecases/sign_in_with_google.dart';
import '../../../auth/presentation/viewmodels/auth_providers.dart';

/// ViewModel backing the onboarding feature. Wraps the [AuthViewModel]
/// so the UI never reaches into the auth feature directly.
class OnboardingViewModel {
  OnboardingViewModel(this._ref);

  final Ref _ref;

  /// Whether the auth flow is currently busy.
  bool get isLoading => _ref.watch(authControllerProvider).value?.isLoading ?? false;

  /// Latest error message surfaced by the auth flow, if any.
  String? get errorMessage => _ref.read(authControllerProvider).value?.errorMessage;

  /// Triggers the Google sign-in flow through the auth use case and
  /// returns the discriminated result so the button can branch on
  /// success / cancellation / failure without inspecting exceptions.
  Future<SignInWithGoogleResult> signInWithGoogle() {
    return _ref.read(authControllerProvider.notifier).signInWithGoogle();
  }
}

/// Provider exposing the [OnboardingViewModel] to the widget tree.
final onboardingViewModelProvider = Provider<OnboardingViewModel>(
  OnboardingViewModel.new,
);