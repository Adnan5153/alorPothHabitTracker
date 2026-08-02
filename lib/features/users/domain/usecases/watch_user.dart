import '../app_user.dart';
import '../user_repository.dart';

/// Streams the [AppUser] document for the given uid. Emits `null` while
/// the document is missing or the underlying stream is still warming up.
class WatchUser {
  const WatchUser(this._repository);
  final UserRepository _repository;

  Stream<AppUser?> call(String uid) => _repository.watchById(uid);
}
