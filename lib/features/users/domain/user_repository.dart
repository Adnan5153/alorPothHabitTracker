import 'app_user.dart';

/// Contract for any backing store that can persist user profiles. Kept in
/// the domain layer so the rest of the app talks to a single interface
/// and tests can substitute a fake without touching Firestore.
abstract class UserRepository {
  static const String collectionName = 'users';

  /// Returns the [AppUser] for [uid] or `null` if the document does not
  /// exist yet.
  Future<AppUser?> fetchById(String uid);

  /// Creates the user document if missing, otherwise returns the
  /// existing one. Implementations must treat the call as idempotent.
  Future<AppUser> ensureDocument(AppUser user);

  /// Replaces the [UserStats] block with a new value computed from the
  /// provided [AppUser] snapshot. Implementation is free to use any
  /// granular merge strategy.
  Future<AppUser> persist(AppUser user);

  /// Streams the user document. Emits `null` when the document does not
  /// exist yet.
  Stream<AppUser?> watchById(String uid);
}
