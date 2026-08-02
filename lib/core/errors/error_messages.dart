import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseException;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/services.dart' show PlatformException;
import 'package:google_sign_in/google_sign_in.dart'
    show GoogleSignInException, GoogleSignInExceptionCode;

/// Translates provider-agnostic exceptions into short, user-facing messages
/// suitable for a SnackBar. Centralising this keeps Firebase-specific
/// identifiers from leaking into the UI.
class ErrorMessages {
  ErrorMessages._();

  static String from(Object error) {
    if (error is FirebaseAuthException) {
      return _fromAuth(error);
    }
    if (error is FirebaseException) {
      return _fromFirestore(error);
    }
    if (error is GoogleSignInException) {
      return _fromGoogleSignIn(error);
    }
    if (error is PlatformException) {
      return _fromPlatform(error);
    }
    return 'Something went wrong. Please try again.';
  }

  static String _fromFirestore(FirebaseException error) {
    switch (error.code) {
      case 'permission-denied':
        return 'You do not have permission to perform this action.';
      case 'unavailable':
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'not-found':
        return 'The requested resource was not found.';
      case 'already-exists':
        return 'This resource already exists.';
      case 'resource-exhausted':
        return 'Too many requests. Please try again later.';
      case 'failed-precondition':
        return 'This action cannot be completed right now.';
      case 'cancelled':
        return 'The operation was cancelled.';
      default:
        return 'A database error occurred. Please try again.';
    }
  }

  static String _fromGoogleSignIn(GoogleSignInException error) {
    switch (error.code) {
      case GoogleSignInExceptionCode.canceled:
        return 'Sign-in was cancelled.';
      case GoogleSignInExceptionCode.interrupted:
        return 'Sign-in was interrupted. Please try again.';
      case GoogleSignInExceptionCode.clientConfigurationError:
        return 'Google Sign-In is misconfigured.';
      case GoogleSignInExceptionCode.providerConfigurationError:
        return 'Sign-in provider is unavailable.';
      case GoogleSignInExceptionCode.uiUnavailable:
        return 'Google Sign-In UI is not available on this device.';
      case GoogleSignInExceptionCode.userMismatch:
        return 'A different account is already signed in.';
      case GoogleSignInExceptionCode.unknownError:
        return 'Sign-in failed. Please try again.';
    }
  }

  static String _fromAuth(FirebaseAuthException error) {
    switch (error.code) {
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method.';
      case 'invalid-credential':
      case 'invalid-verification-code':
      case 'invalid-verification-id':
        return 'The credential is invalid or has expired.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled. Please contact support.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account was found for those credentials.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'popup-closed-by-user':
      case 'cancelled-popup-request':
      case 'user-cancelled':
        return 'Sign-in was cancelled.';
      default:
        return 'Sign-in failed. Please try again.';
    }
  }

  static String _fromPlatform(PlatformException error) {
    switch (error.code) {
      case 'sign_in_canceled':
      case 'sign_in_failed':
        return 'Sign-in was cancelled.';
      case 'network_error':
        return 'Network error. Please check your connection.';
      case 'play_services_not_installed':
      case 'missing_pluggy':
        return 'Google Play Services are unavailable on this device.';
      default:
        return 'Sign-in failed. Please try again.';
    }
  }
}
