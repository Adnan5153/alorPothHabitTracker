import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/app_user.dart';
import '../../../domain/user_repository.dart';
import '../../models/user_dto.dart';

/// Talks to Firestore on behalf of the [UserRepository] implementation.
/// Keeping the SDK confined to the datasource makes the repository
/// trivially fakeable in tests.
class FirestoreUserDatasource {
  FirestoreUserDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(UserRepository.collectionName);

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _collection.doc(uid);

  Future<AppUser?> fetchById(String uid) async {
    final snapshot = await _doc(uid).get();
    if (!snapshot.exists) return null;
    return UserDto.fromSnapshot(snapshot).toAppUser();
  }

  /// Create-if-missing write with `SetOptions(merge: true)`. This is the
  /// single source of truth for the create-or-update semantic so we never
  /// end up racing a read against a write.
  Future<AppUser> ensureDocument(AppUser user) async {
    final ref = _doc(user.uid);
    developer.log(
      'Firestore set users/${user.uid} merge=true',
      name: 'FirestoreUserDatasource',
    );
    await ref.set(
      UserDto.fromAppUser(user).toMergeMap(),
      SetOptions(merge: true),
    );
    return user;
  }

  Future<AppUser> persist(AppUser user) async {
    final ref = _doc(user.uid);
    developer.log(
      'Firestore set users/${user.uid} merge=true (persist)',
      name: 'FirestoreUserDatasource',
    );
    await ref.set(
      UserDto.fromAppUser(user).toMergeMap(),
      SetOptions(merge: true),
    );
    return user;
  }

  Stream<AppUser?> watchById(String uid) {
    return _doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return UserDto.fromSnapshot(snapshot).toAppUser();
    });
  }
}