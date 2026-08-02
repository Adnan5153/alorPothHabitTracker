import 'package:flutter/material.dart';

import '../../../animations/app_animations.dart';
import '../../appbar/app_bar_extensions.dart';
import '../liquid_safe_area/liquid_safe_area.dart';
import '../liquid_scaffold_extensions/liquid_scaffold_context_extensions.dart';
import 'liquid_body_constants.dart';

/// Composes the body slot: SafeArea → optional padding (explicit or
/// responsive) → optional `SingleChildScrollView` with
/// `ClampingScrollPhysics` → optional fade-up entrance animation.
class LiquidBody extends StatelessWidget {
  const LiquidBody({
    super.key,
    required this.child,
    this.padding,
    this.responsivePadding = false,
    this.scrollable = false,
    this.entranceAnimation = false,
    this.safeTop = true,
    this.safeBottom = true,
    this.safeLeft = true,
    this.safeRight = true,
    this.physics,
  });

  final Widget child;
  final EdgeInsets? padding;
  final bool responsivePadding;
  final bool scrollable;
  final bool entranceAnimation;
  final bool safeTop;
  final bool safeBottom;
  final bool safeLeft;
  final bool safeRight;
  final ScrollPhysics? physics;

  EdgeInsets _resolvePadding(BuildContext context) {
    if (padding != null) return padding!;
    if (!responsivePadding) return LiquidBodyDefaults.defaultPadding;
    final responsive = context.liquidScaffoldTheme.responsiveVerticalPadding;
    final vertical = context.isDesktop
        ? responsive.desktop
        : context.isTablet
            ? responsive.tablet
            : responsive.compact;
    return EdgeInsets.symmetric(
      horizontal: context.liquidScaffoldTheme.horizontalPadding,
      vertical: vertical,
    );
  }

  @override
  Widget build(BuildContext context) {
    final padded = Padding(padding: _resolvePadding(context), child: child);
    final scrolled = !scrollable
        ? padded
        : SingleChildScrollView(
            physics: physics ?? const ClampingScrollPhysics(),
            child: padded,
          );
    final animated =
        entranceAnimation ? scrolled.fadeUpEntrance(delay: AppAnims.standard) : scrolled;
    return LiquidSafeArea(
      top: safeTop,
      bottom: safeBottom,
      left: safeLeft,
      right: safeRight,
      child: animated,
    );
  }
}
