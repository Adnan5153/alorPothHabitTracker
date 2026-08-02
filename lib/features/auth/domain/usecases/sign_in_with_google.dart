import 'package:google_sign_in/google_sign_in.dart'
    show GoogleSignInException, GoogleSignInExceptionCode;

import '../../data/services/google_sign_in_service.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// Outcome of [SignInWithGoogle.call]. Distinguishes a real failure
/// from a user-driven cancellation so the presentation layer never
/// renders a SnackBar for a no-op.
class SignInWithGoogleResult {
  const SignInWithGoogleResult._({this.user, this.error});

  const SignInWithGoogleResult.success(AuthUser user) : this._(user: user);
  const SignInWithGoogleResult.cancelled() : this._();
  const SignInWithGoogleResult.failure(Object error) : this._(error: error);

  final AuthUser? user;
  final Object? error;

  bool get isSuccess => user != null;
  bool get isCancelled => user == null && error == null;
  bool get isFailure => error != null;
}

/// Single-responsibility use case: trigger a Google sign-in flow and
/// translate SDK outcomes into a domain-neutral [SignInWithGoogleResult].
class SignInWithGoogle {
  const SignInWithGoogle(this._repository);
  final AuthRepository _repository;

  Future<SignInWithGoogleResult> call() async {
    try {
      final user = await _repository.signInWithGoogle();
      return SignInWithGoogleResult.success(user);
    } on GoogleSignInCancelledException {
      return const SignInWithGoogleResult.cancelled();
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        return const SignInWithGoogleResult.cancelled();
      }
      return SignInWithGoogleResult.failure(error);
    } catch (error) {
      return SignInWithGoogleResult.failure(error);
    }
  }
}