import '../entities/auth_user.dart';

/// Contract that the data layer fulfils. The presentation layer only
/// ever talks to this interface, never to Firebase.
abstract class AuthRepository {
  Stream<AuthUser> watchAuthState();

  AuthUser currentUser();

  Future<AuthUser> signInWithGoogle();

  Future<void> signOut();
}
