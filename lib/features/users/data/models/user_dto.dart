import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/app_user.dart';
import '../../domain/user_provider.dart';
import '../../domain/user_stats.dart';

/// Firestore DTO for the `users/{uid}` document. Knows the exact wire
/// shape and is the only place the field names are spelled out — the rest
/// of the app exchanges [AppUser] domain objects.
class UserDto {
  const UserDto._({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoURL,
    required this.provider,
    required this.createdAt,
    required this.updatedAt,
    required this.stats,
  });

  final String uid;
  final String displayName;
  final String email;
  final String photoURL;
  final UserProvider provider;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserStats stats;

  static const String fieldDisplayName = 'displayName';
  static const String fieldEmail = 'email';
  static const String fieldPhotoURL = 'photoURL';
  static const String fieldProvider = 'provider';
  static const String fieldCreatedAt = 'createdAt';
  static const String fieldUpdatedAt = 'updatedAt';
  static const String fieldStats = '_stats';
  static const String fieldStatsIsPremium = 'isPremium';
  static const String fieldStatsXp = 'xp';
  static const String fieldStatsLevel = 'level';
  static const String fieldStatsStreak = 'streak';
  static const String fieldStatsLastActiveAt = 'lastActiveAt';

  factory UserDto.fromAppUser(AppUser user) {
    return UserDto._(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
      photoURL: user.photoURL,
      provider: user.provider,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      stats: user.stats,
    );
  }

  factory UserDto.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? const <String, dynamic>{};
    return UserDto._(
      uid: snapshot.id,
      displayName: (data[fieldDisplayName] as String?) ?? '',
      email: (data[fieldEmail] as String?) ?? '',
      photoURL: (data[fieldPhotoURL] as String?) ?? '',
      provider: UserProvider.fromWire(data[fieldProvider] as String?),
      createdAt: _readDateTime(data[fieldCreatedAt]),
      updatedAt: _readDateTime(data[fieldUpdatedAt]),
      stats: UserStats.fromMap(
        Map<String, dynamic>.from(
          (data[fieldStats] as Map<dynamic, dynamic>?) ?? const {},
        ),
      ),
    );
  }

  AppUser toAppUser() {
    final now = DateTime.now().toUtc();
    return AppUser(
      uid: uid,
      displayName: displayName,
      email: email,
      photoURL: photoURL,
      provider: provider,
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? now,
      stats: stats,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      fieldDisplayName: displayName,
      fieldEmail: email,
      fieldPhotoURL: photoURL,
      fieldProvider: provider.wire,
      fieldCreatedAt: createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      fieldUpdatedAt: FieldValue.serverTimestamp(),
      fieldStats: stats.toMap(),
    };
  }

  /// Granular payload for partial updates. Only the keys that change are
  /// surfaced so concurrent writes (e.g. two clients updating XP) do not
  /// overwrite each other.
  Map<String, dynamic> toMergeMap() {
    return {
      'uid': uid,
      fieldDisplayName: displayName,
      fieldEmail: email,
      fieldPhotoURL: photoURL,
      fieldProvider: provider.wire,
      fieldUpdatedAt: FieldValue.serverTimestamp(),
      fieldStats: stats.toMap(),
    };
  }

  static DateTime? _readDateTime(Object? raw) {
    if (raw == null) return null;
    if (raw is Timestamp) return raw.toDate();
    if (raw is DateTime) return raw;
    if (raw is String) return DateTime.tryParse(raw);
    if (raw is int) return DateTime.fromMillisecondsSinceEpoch(raw);
    return null;
  }
}
