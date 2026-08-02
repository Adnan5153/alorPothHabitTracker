import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/firebase_providers.dart';
import '../../data/datasources/remote/firebase_auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/services/google_sign_in_service.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/watch_auth_state.dart';
import 'auth_viewmodel.dart';

/// Concrete repository wired against the Firebase-backed datasource. Tests
/// can override this with a fake to bypass the SDK entirely.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final googleSignIn = ref.watch(googleSignInServiceProvider);
  final datasource = FirebaseAuthDatasource(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    googleSignIn: googleSignIn,
  );
  return AuthRepositoryImpl(datasource);
});

/// Wraps the GoogleSignIn SDK so the data layer has a single integration
/// point. Surfacing it as a provider lets tests swap in a fake.
final googleSignInServiceProvider = Provider<GoogleSignInService>(
  (ref) => GoogleSignInService(),
);

/// Use case: stream the current auth user.
final watchAuthStateProvider = Provider<WatchAuthState>(
  (ref) => WatchAuthState(ref.watch(authRepositoryProvider)),
);

/// Use case: trigger a Google sign-in flow.
final signInWithGoogleProvider = Provider<SignInWithGoogle>(
  (ref) => SignInWithGoogle(ref.watch(authRepositoryProvider)),
);

/// Use case: sign out the current user.
final signOutUseCaseProvider = Provider<SignOutUseCase>(
  (ref) => SignOutUseCase(ref.watch(authRepositoryProvider)),
);

/// AsyncNotifier exposing the [AuthState] to the widget tree. The
/// router listens to this provider to drive refresh redirects.
final authControllerProvider =
    AsyncNotifierProvider<AuthViewModel, AuthState>(AuthViewModel.new);

/// Backwards-compatible alias used by older call sites.
final authProvider = authControllerProvider;

/// Convenience accessor that returns the latest [AuthUser] (or `null`
/// when the AsyncNotifier is still warming up).
final currentAuthUserProvider = Provider<AuthUser?>((ref) {
  final auth = ref.watch(authControllerProvider);
  return auth.value?.user;
});