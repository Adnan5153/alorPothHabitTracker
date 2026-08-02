import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart' show User;

import '../../../../core/errors/error_messages.dart';
import '../app_user.dart';
import '../user_provider.dart';
import '../user_repository.dart';

/// Ensures a `users/{uid}` document exists for the currently signed-in
/// Firebase [User]. Idempotent: returns the existing document when one
/// is already present, otherwise writes a fresh [AppUser.initial] record.
///
/// The use case delegates the create-or-update to the repository so the
/// Firestore semantics live in one place. Network and permission errors
/// are caught and rethrown as [EnsureUserDocumentException] so the
/// presentation layer can surface a meaningful message instead of silently
/// swallowing the failure.
class EnsureUserDocument {
  const EnsureUserDocument(this._repository);
  final UserRepository _repository;

  Future<AppUser> call(User firebaseUser) async {
    try {
      final initial = AppUser.initial(
        firebaseUser: firebaseUser,
        provider: UserProvider.fromFirebaseId(
          firebaseUser.providerData.isNotEmpty
              ? firebaseUser.providerData.first.providerId
              : null,
        ),
      );
      final result = await _repository.ensureDocument(initial);
      developer.log(
        'ensureUserDocument ok uid=${result.uid} createdAt=${result.createdAt}',
        name: 'EnsureUserDocument',
      );
      return result;
    } catch (error, stack) {
      developer.log(
        'ensureUserDocument failed uid=${firebaseUser.uid} error=$error',
        name: 'EnsureUserDocument',
        error: error,
        stackTrace: stack,
      );
      throw EnsureUserDocumentException(
        uid: firebaseUser.uid,
        message: ErrorMessages.from(error),
        cause: error,
      );
    }
  }
}

/// Typed exception surfaced when the Firestore write fails. The auth
/// feature's view-model catches this and renders the message instead of
/// silently dropping it on the floor.
class EnsureUserDocumentException implements Exception {
  const EnsureUserDocumentException({
    required this.uid,
    required this.message,
    this.cause,
  });

  final String uid;
  final String message;
  final Object? cause;

  @override
  String toString() => 'EnsureUserDocumentException(uid=$uid, message=$message)';
}