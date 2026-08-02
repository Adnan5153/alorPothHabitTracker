import 'package:firebase_auth/firebase_auth.dart' show User;

import '../app_user.dart';
import '../user_repository.dart';
import '../user_stats.dart';

/// Persists a new [UserStats] block on the current user's document.
/// Other profile metadata (displayName, email, photoURL, provider) is
/// re-derived from the [User] record so concurrent writes to the stats
/// field don't accidentally overwrite fresh profile updates.
class UpdateUserStats {
  const UpdateUserStats(this._repository);
  final UserRepository _repository;

  Future<AppUser> call(User firebaseUser, UserStats stats) async {
    final existing =
        await _repository.fetchById(firebaseUser.uid) ??
            AppUser.initial(
              firebaseUser: firebaseUser,
              provider: null,
            );
    final updated = existing.copyWith(
      displayName: firebaseUser.displayName ?? existing.displayName,
      email: firebaseUser.email ?? existing.email,
      photoURL: firebaseUser.photoURL ?? existing.photoURL,
      stats: stats,
      updatedAt: DateTime.now().toUtc(),
    );
    return _repository.persist(updated);
  }
}
