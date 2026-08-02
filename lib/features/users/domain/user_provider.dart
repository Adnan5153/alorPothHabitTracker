/// Auth providers supported by the application. Stored on the
/// `users/{uid}` document so we can later branch behaviour (e.g. link
/// providers, surface provider-specific UI) without reaching into
/// `FirebaseUser.providerData`.
enum UserProvider {
  google('google'),
  apple('apple'),
  facebook('facebook'),
  email('email'),
  anonymous('anonymous'),
  unknown('unknown');

  const UserProvider(this.wire);

  /// Stable wire-format identifier persisted in Firestore.
  final String wire;

  static UserProvider fromWire(String? raw) {
    if (raw == null) return UserProvider.unknown;
    for (final candidate in UserProvider.values) {
      if (candidate.wire == raw) return candidate;
    }
    return UserProvider.unknown;
  }

  static UserProvider fromFirebaseId(String? providerId) {
    switch (providerId) {
      case 'google.com':
        return UserProvider.google;
      case 'apple.com':
        return UserProvider.apple;
      case 'facebook.com':
        return UserProvider.facebook;
      case 'password':
        return UserProvider.email;
      case 'anonymous':
        return UserProvider.anonymous;
      default:
        return UserProvider.unknown;
    }
  }
}
