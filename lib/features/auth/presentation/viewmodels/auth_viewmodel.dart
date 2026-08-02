import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/firebase_providers.dart';
import '../../../users/domain/usecases/ensure_user_document.dart';
import '../../../users/presentation/viewmodels/user_viewmodel.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import 'auth_providers.dart';

/// Pure presentation model for the auth feature. Holds the latest
/// [AuthUser] (or `null` when nobody is signed in) plus a loading flag
/// and any user-facing error message surfaced from the sign-in flow.
class AuthState {
  const AuthState({
    required this.user,
    required this.isLoading,
    this.errorMessage,
  });

  const AuthState.signedOut()
      : user = null,
        isLoading = false,
        errorMessage = null;

  /// Authenticated user, or `null` when nobody is signed in.
  final AuthUser? user;

  /// `true` while a sign-in or sign-out call is in flight so the UI can
  /// disable interaction.
  final bool isLoading;

  /// User-facing error message rendered by the presentation layer. Bound
  /// to a SnackBar — repositories and use cases never throw strings.
  final String? errorMessage;

  bool get isSignedIn => user != null && user!.isSignedIn;

  AuthState copyWith({
    Object? user = _sentinel,
    bool? isLoading,
    Object? errorMessage = _sentinel,
  }) {
    return AuthState(
      user: identical(user, _sentinel)
          ? this.user
          : user as AuthUser?,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  static const Object _sentinel = Object();
}

/// AsyncNotifier backing the auth feature. Delegates every side effect
/// to a use case so the widget tree stays free of Firebase imports.
class AuthViewModel extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final watch = ref.watch(watchAuthStateProvider);
    final subscription = watch.call().listen((authUser) {
      // Publish the latest auth state immediately so consumers (router,
      // dashboard) don't have to wait on the Firestore bootstrap.
      state = AsyncData(
        AuthState(user: authUser, isLoading: false, errorMessage: null),
      );

      if (!authUser.isSignedIn) return;

      // Bootstrap (idempotent) the Firestore user document on every
      // sign-in so profile metadata stays in sync. The write runs off
      // the listener microtask so the first frame after navigation
      // never blocks on a Firestore roundtrip.
      Future.microtask(_bootstrapUserDocument);
    });
    ref.onDispose(subscription.cancel);

    // Seed with the current user (empty AuthUser when nobody is signed
    // in) so consumers don't have to special-case loading.
    final current = ref.read(currentAuthUserProvider);
    return AuthState(user: current, isLoading: false, errorMessage: null);
  }

  Future<void> _bootstrapUserDocument() async {
    try {
      final firebaseUser = ref.read(firebaseAuthProvider).currentUser;
      if (firebaseUser == null) return;
      await ref.read(ensureUserDocumentProvider).call(firebaseUser);
    } on EnsureUserDocumentException catch (error) {
      final previous = state.value ?? const AuthState.signedOut();
      state = AsyncData(previous.copyWith(errorMessage: error.message));
    } catch (error) {
      final previous = state.value ?? const AuthState.signedOut();
      state = AsyncData(previous.copyWith(errorMessage: error.toString()));
    }
  }

  /// Triggers the Google sign-in flow through the use case. Cancellation
  /// is a no-op: the loading flag clears, no error surfaces, no exception
  /// propagates. Real failures populate [AuthState.errorMessage].
  Future<SignInWithGoogleResult> signInWithGoogle() async {
    if (state.value?.isLoading ?? false) {
      return const SignInWithGoogleResult.cancelled();
    }
    state = AsyncData(
      (state.value ?? const AuthState.signedOut()).copyWith(
        isLoading: true,
        errorMessage: null,
      ),
    );
    final result = await ref.read(signInWithGoogleProvider).call();
    final previous = state.value ?? const AuthState.signedOut();
    state = AsyncData(
      previous.copyWith(
        isLoading: false,
        errorMessage: result.isFailure ? result.error.toString() : null,
      ),
    );
    return result;
  }

  /// Signs out via the use case. Errors are surfaced through the state
  /// and rethrown so the UI can react.
  Future<void> signOut() async {
    if (state.value?.isLoading ?? false) return;
    state = AsyncData(
      (state.value ?? const AuthState.signedOut()).copyWith(isLoading: true),
    );
    try {
      await ref.read(signOutUseCaseProvider).call();
    } catch (error) {
      state = AsyncData(
        (state.value ?? const AuthState.signedOut()).copyWith(
          isLoading: false,
          errorMessage: error.toString(),
        ),
      );
      rethrow;
    }
  }
}

/// Backwards-compatibility alias for the original controller name.
typedef AuthController = AuthViewModel;