import 'package:firebase_auth/firebase_auth.dart' show User;

import '../../domain/entities/auth_user.dart';

/// Maps the Firebase Authentication [User] to the auth feature's pure
/// [AuthUser] entity. The mapper lives in the data layer so the domain
/// layer never imports Firebase.
extension AuthUserMapper on User {
  AuthUser toAuthUser() => AuthUser(
        uid: uid,
        email: email ?? '',
        displayName: displayName ?? '',
        photoURL: photoURL ?? '',
        isAnonymous: isAnonymous,
      );
}

extension AuthUserNullMapper on User? {
  AuthUser toAuthUserOrEmpty() {
    final user = this;
    if (user == null) return AuthUser.empty;
    return user.toAuthUser();
  }
}
