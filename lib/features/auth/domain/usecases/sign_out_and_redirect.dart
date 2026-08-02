import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../repositories/auth_repository.dart';

/// Use case: sign the current user out and navigate to the onboarding
/// screen. The redirect target is supplied by the caller so the use case
/// remains decoupled from the routing configuration.
class SignOutAndRedirect {
  const SignOutAndRedirect(this._repository);
  final AuthRepository _repository;

  /// Signs out and then redirects [router] to [destination] (defaults to
  /// the onboarding route). Returns the destination after the
  /// redirect has been issued.
  Future<String> call(GoRouter router, {String destination = AppRoutes.onboarding}) async {
    await _repository.signOut();
    router.go(destination);
    return destination;
  }
}
