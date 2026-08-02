import 'dart:developer' as developer;

import '../../domain/app_user.dart';
import '../../domain/user_repository.dart';
import '../datasources/remote/firestore_user_datasource.dart';

/// Firestore-backed implementation of [UserRepository]. The repository is
/// the only place that talks to Firestore — the rest of the app exchanges
/// pure [AppUser] instances.
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._datasource);

  final FirestoreUserDatasource _datasource;

  @override
  Future<AppUser?> fetchById(String uid) => _datasource.fetchById(uid);

  @override
  Future<AppUser> ensureDocument(AppUser user) async {
    developer.log(
      'UserRepository.ensureDocument uid=${user.uid}',
      name: 'UserRepository',
    );
    return _datasource.ensureDocument(user);
  }

  @override
  Future<AppUser> persist(AppUser user) => _datasource.persist(user);

  @override
  Stream<AppUser?> watchById(String uid) => _datasource.watchById(uid);
}