/// Centralised route identifiers used by the GoRouter configuration.
///
/// Keep these as the single source of truth so navigation calls never hard
/// code paths that could drift away from the router definition.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
}
