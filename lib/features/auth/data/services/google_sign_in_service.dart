import 'package:google_sign_in/google_sign_in.dart'
    show GoogleSignIn, GoogleSignInException;

/// Raised when the user cancels the Google Sign-In flow. Distinct from
/// SDK failures so the use case can branch on intent vs. error.
class GoogleSignInCancelledException implements Exception {
  const GoogleSignInCancelledException();
}

/// Wraps the GoogleSignIn SDK so the data layer has a single integration
/// point. The service is the only place that calls `authenticate()`.
class GoogleSignInService {
  GoogleSignInService({GoogleSignIn? client})
      : _client = client ?? GoogleSignIn.instance;

  final GoogleSignIn _client;
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await _client.initialize();
    _initialized = true;
  }

  Future<({String? idToken})> authenticate() async {
    await _ensureInitialized();
    try {
      final account = await _client.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        // Empty token is treated as a user-initiated cancel because the
        // SDK only returns `null`/empty when the account was not picked.
        throw const GoogleSignInCancelledException();
      }
      return (idToken: idToken);
    } on GoogleSignInException {
      // Re-throw as-is so the caller can inspect `code` and `details`.
      // We deliberately do NOT map SDK exceptions to
      // GoogleSignInCancelledException here because v7 reports many
      // infrastructure failures (Credential Manager errors, missing
      // OAuth client, Play Services unavailable) as `canceled`.
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _client.signOut();
  }
}