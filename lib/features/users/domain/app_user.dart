import 'package:firebase_auth/firebase_auth.dart' show User;

import 'user_provider.dart';
import 'user_stats.dart';

/// Pure domain model for an authenticated user. Owns no Firebase types
/// (other than the optional [User] reference passed to the factory) so the
/// widget tree can render and reason about users without depending on the
/// Firestore shape.
class AppUser {
  const AppUser({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoURL,
    required this.provider,
    required this.createdAt,
    required this.updatedAt,
    required this.stats,
  });

  factory AppUser.initial({
    required User firebaseUser,
    UserProvider? provider,
  }) {
    final now = DateTime.now().toUtc();
    return AppUser(
      uid: firebaseUser.uid,
      displayName: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? '',
      photoURL: firebaseUser.photoURL ?? '',
      provider: provider ?? UserProvider.unknown,
      createdAt: now,
      updatedAt: now,
      stats: const UserStats.initial(),
    );
  }

  final String uid;
  final String displayName;
  final String email;
  final String photoURL;
  final UserProvider provider;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserStats stats;

  AppUser copyWith({
    String? displayName,
    String? email,
    String? photoURL,
    UserProvider? provider,
    DateTime? updatedAt,
    UserStats? stats,
  }) {
    return AppUser(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      provider: provider ?? this.provider,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      stats: stats ?? this.stats,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AppUser &&
      other.uid == uid &&
      other.displayName == displayName &&
      other.email == email &&
      other.photoURL == photoURL &&
      other.provider == provider &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.stats == stats;

  @override
  int get hashCode => Object.hash(
        uid,
        displayName,
        email,
        photoURL,
        provider,
        createdAt,
        updatedAt,
        stats,
      );
}
