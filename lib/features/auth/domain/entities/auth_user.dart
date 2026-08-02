/// Pure domain representation of the authenticated user. The auth feature
/// keeps its own entity (separate from the `users` feature's `AppUser`)
/// because the auth flow only needs the identity surface — profile
/// metadata lives in the `users` feature.
class AuthUser {
  const AuthUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoURL,
    required this.isAnonymous,
  });

  final String uid;
  final String email;
  final String displayName;
  final String photoURL;
  final bool isAnonymous;

  bool get isSignedIn => uid.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      other is AuthUser &&
      other.uid == uid &&
      other.email == email &&
      other.displayName == displayName &&
      other.photoURL == photoURL &&
      other.isAnonymous == isAnonymous;

  @override
  int get hashCode =>
      Object.hash(uid, email, displayName, photoURL, isAnonymous);

  static const AuthUser empty = AuthUser(
    uid: '',
    email: '',
    displayName: '',
    photoURL: '',
    isAnonymous: false,
  );
}
