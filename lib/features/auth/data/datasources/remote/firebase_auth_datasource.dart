import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, GoogleAuthProvider, User;

import '../../services/google_sign_in_service.dart';

/// Talks to Firebase Authentication and the Google Sign-In SDK. The
/// datasource returns only Firebase-native types so the repository can
/// map them without leaking Firebase into the domain layer.
class FirebaseAuthDatasource {
  FirebaseAuthDatasource({
    required FirebaseAuth firebaseAuth,
    required GoogleSignInService googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignInService _googleSignIn;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  User? currentUser() => _firebaseAuth.currentUser;

  Future<User?> signInWithGoogle() async {
    final tokens = await _googleSignIn.authenticate();
    final idToken = tokens.idToken;
    if (idToken == null) {
      throw StateError('Google sign-in returned no id token.');
    }
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    return userCredential.user;
  }

  Future<void> signOut() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      for (final provider in user.providerData) {
        if (provider.providerId == 'google.com') {
          await _googleSignIn.signOut();
          break;
        }
      }
    }
    await _firebaseAuth.signOut();
  }
}
