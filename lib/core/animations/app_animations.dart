import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../liquidGlass/transitions/liquid_transition.dart';

/// Centralised animation durations and curves for the application. Keeping
/// these as named constants ensures every screen burns the same animation
/// language and avoids arbitrary magic numbers drifting across the app.
class AppAnims {
  AppAnims._();

  static const Duration micro = Duration(milliseconds: 180);
  static const Duration standard = Duration(milliseconds: 320);
  static const Duration page = Duration(milliseconds: 420);
  static const Duration hero = Duration(milliseconds: 600);

  static const Curve enterCurve = Curves.easeOutCubic;
  static const Curve pageCurve = Curves.easeInOutCubic;
  static const Curve microCurve = Curves.easeOut;
}

/// Convenient, opinionated entrance effects built on top of `flutter_animate`.
/// Use these instead of writing raw `.animate()...` chains for every common
/// case (page content, cards, buttons, list items).
extension AppAnimateExtensions on Widget {
  /// Subtle fade + slide-up entrance for page-level content.
  Widget fadeUpEntrance({Duration delay = Duration.zero}) {
    return animate()
        .fadeIn(duration: AppAnims.standard, curve: AppAnims.enterCurve, delay: delay)
        .moveY(begin: 16, end: 0, duration: AppAnims.standard, curve: AppAnims.enterCurve, delay: delay);
  }

  /// Fade + scale-fade entrance for hero widgets (avatars, large titles).
  Widget scaleFadeEntrance({Duration delay = Duration.zero}) {
    return animate()
        .fadeIn(duration: AppAnims.standard, curve: AppAnims.enterCurve, delay: delay)
        .scale(begin: const Offset(0.92, 0.92), duration: AppAnims.standard, curve: AppAnims.enterCurve, delay: delay);
  }

  /// Pure fade-in for chrome (AppBar, dividers, chips).
  Widget fadeIn({Duration delay = Duration.zero}) {
    return animate().fadeIn(
      duration: AppAnims.standard,
      curve: AppAnims.enterCurve,
      delay: delay,
    );
  }

  /// Short fade-in for transient liquid chrome such as loading indicators.
  Widget fadeInMicro({Duration delay = Duration.zero}) {
    return animate().fadeIn(
      duration: LiquidMotion.micro,
      curve: AppAnims.microCurve,
      delay: delay,
    );
  }
}
