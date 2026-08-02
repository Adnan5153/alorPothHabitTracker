import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;

import '../../../../core/di/firebase_providers.dart';
import '../../data/datasources/remote/firestore_user_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/app_user.dart';
import '../../domain/user_repository.dart';
import '../../domain/usecases/ensure_user_document.dart';
import '../../domain/usecases/update_user_stats.dart';
import '../../domain/usecases/watch_user.dart';
import '../../domain/user_stats.dart';

/// Concrete repository wired against the Firestore datasource. Tests can
/// override this with a fake to bypass the SDK entirely.
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final datasource = FirestoreUserDatasource(
    firestore: ref.watch(firebaseFirestoreProvider),
  );
  return UserRepositoryImpl(datasource);
});

/// Use case: ensure a `users/{uid}` document exists for the given
/// Firebase [User]. Idempotent.
final ensureUserDocumentProvider = Provider<EnsureUserDocument>(
  (ref) => EnsureUserDocument(ref.watch(userRepositoryProvider)),
);

/// Use case: stream the [AppUser] for the given uid.
final watchUserProvider = Provider<WatchUser>(
  (ref) => WatchUser(ref.watch(userRepositoryProvider)),
);

/// Use case: persist a new [UserStats] block on the current user.
final updateUserStatsProvider = Provider<UpdateUserStats>(
  (ref) => UpdateUserStats(ref.watch(userRepositoryProvider)),
);

/// Streams the [AppUser] document for the given uid. Returns `null`
/// while the document is missing or the stream is still warming up.
final userDocumentProvider =
    StreamProvider.family<AppUser?, String>((ref, uid) {
  final repo = ref.watch(watchUserProvider);
  return repo.call(uid);
});

/// Streams the [AppUser] for the currently authenticated user. Emits
/// `null` when nobody is signed in.
final currentUserProvider = StreamProvider<AppUser?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final repo = ref.watch(watchUserProvider);
  return auth.authStateChanges().asyncMap((user) async {
    if (user == null) return null;
    return repo.call(user.uid).first;
  });
});

/// Convenience accessor for the current Firebase [User] (or `null` when
/// nobody is signed in). Lets cross-feature VMs avoid touching the
/// underlying Firebase singleton directly.
final currentFirebaseUserProvider = Provider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).currentUser;
});

/// ViewModel for the users feature. Thin façade that wraps the use cases
/// — the widget tree never reaches into the repository directly.
class UserViewModel {
  UserViewModel(this._ref);

  final Ref _ref;

  /// Convenience access to the FCM user from the [firebaseAuthProvider].
  User? get currentFirebaseUser => _ref.read(firebaseAuthProvider).currentUser;

  /// Ensures a Firestore user document exists for [firebaseUser].
  Future<AppUser> ensureUserDocument(User firebaseUser) {
    return _ref.read(ensureUserDocumentProvider).call(firebaseUser);
  }

  /// Streams the [AppUser] document for [uid].
  Stream<AppUser?> watchUser(String uid) {
    return _ref.read(watchUserProvider).call(uid);
  }

  /// Persists a new [UserStats] block on the current user.
  Future<AppUser> updateUserStats(User firebaseUser, UserStats stats) {
    return _ref.read(updateUserStatsProvider).call(firebaseUser, stats);
  }
}

/// Provider usable by widgets that want the ViewModel instance directly.
final userViewModelProvider = Provider<UserViewModel>(UserViewModel.new);
