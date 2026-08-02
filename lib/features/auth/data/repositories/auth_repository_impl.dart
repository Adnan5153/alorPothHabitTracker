import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/firebase_auth_datasource.dart';
import '../models/auth_user_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._datasource);

  final FirebaseAuthDatasource _datasource;

  @override
  Stream<AuthUser> watchAuthState() {
    return _datasource
        .authStateChanges()
        .map((user) => user.toAuthUserOrEmpty());
  }

  @override
  AuthUser currentUser() => _datasource.currentUser().toAuthUserOrEmpty();

  @override
  Future<AuthUser> signInWithGoogle() async {
    final user = await _datasource.signInWithGoogle();
    return user.toAuthUserOrEmpty();
  }

  @override
  Future<void> signOut() => _datasource.signOut();
}
