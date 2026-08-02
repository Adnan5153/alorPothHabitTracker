import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/domain/usecases/sign_out_and_redirect.dart';
import '../../../auth/presentation/viewmodels/auth_providers.dart';

/// ViewModel for the dashboard feature. Surfaces the current
/// [AuthUser] plus a sign-out entry point that wraps the
/// [SignOutAndRedirect] use case.
class DashboardViewModel {
  DashboardViewModel(this._ref);

  final Ref _ref;

  /// Current authenticated user, or `null` when nobody is signed in.
  AuthUser? get currentUser => _ref.watch(currentAuthUserProvider);

  /// Loading flag surfaced by the auth controller.
  bool get isLoading =>
      _ref.watch(authControllerProvider).value?.isLoading ?? false;

  /// Use case: sign out the current user and redirect to onboarding.
  SignOutAndRedirect get signOutAndRedirect =>
      _ref.read(signOutAndRedirectProvider);

  /// Convenience helper that triggers sign-out + redirect.
  Future<void> signOut() async {
    await _ref.read(authControllerProvider.notifier).signOut();
  }
}

/// Provider exposing the [SignOutAndRedirect] use case to the widget tree.
final signOutAndRedirectProvider = Provider<SignOutAndRedirect>(
  (ref) => SignOutAndRedirect(ref.watch(authRepositoryProvider)),
);

/// Provider exposing the [DashboardViewModel] to the widget tree.
final dashboardViewModelProvider = Provider<DashboardViewModel>(
  DashboardViewModel.new,
);