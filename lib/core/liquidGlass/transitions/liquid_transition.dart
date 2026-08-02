import 'package:flutter/material.dart';

/// Animation durations and curves used across the Liquid Glass design
/// system. Centralised so interactive widgets burn the same motion
/// language.
class LiquidMotion {
  LiquidMotion._();

  static const Duration micro = Duration(milliseconds: 120);
  static const Duration press = Duration(milliseconds: 180);
  static const Duration focus = Duration(milliseconds: 220);
  static const Duration page = Duration(milliseconds: 320);

  static const Curve standard = Curves.easeOutCubic;
  static const Curve emphasis = Curves.easeInOutCubic;
  static const Curve pressCurve = Curves.easeInOut;
}

/// Applies a [LiquidMotion] drive to a child, optionally combining
/// fade and a subtle scale for press / hover / focus state changes.
/// Designed to be the canonical "ripple replacement" — every Liquid
/// Glass interactive surface runs its state through this widget.
class LiquidTransition extends StatelessWidget {
  const LiquidTransition({
    super.key,
    required this.animation,
    this.child,
    this.scale = true,
    this.fade = true,
    this.beginScale = 0.96,
  });

  final Animation<double> animation;
  final Widget? child;
  final bool scale;
  final bool fade;
  final double beginScale;

  @override
  Widget build(BuildContext context) {
    Widget result = child ?? const SizedBox.shrink();
    if (fade) {
      result = FadeTransition(opacity: animation, child: result);
    }
    if (scale) {
      result = ScaleTransition(
        scale: Tween<double>(begin: beginScale, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: LiquidMotion.pressCurve),
        ),
        child: result,
      );
    }
    return result;
  }
}

/// Stateful controller that tracks pressed / hovered / focused state and
/// produces a shared animation for interactive Liquid Glass surfaces.
class LiquidPressController extends StatefulWidget {
  const LiquidPressController({
    super.key,
    required this.child,
    this.enabled = true,
    this.duration = LiquidMotion.press,
    this.onPressed,
  });

  final Widget Function(
    BuildContext context,
    Animation<double> animation,
    bool isPressed,
  ) child;
  final bool enabled;
  final Duration duration;
  final VoidCallback? onPressed;

  @override
  State<LiquidPressController> createState() => _LiquidPressControllerState();
}

class _LiquidPressControllerState extends State<LiquidPressController>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setPressed(bool value) {
    if (!widget.enabled || _pressed == value) return;
    setState(() => _pressed = value);
    if (value) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _handleTap() {
    if (!widget.enabled) return;
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: Focus(
        onFocusChange: (focused) => _setPressed(focused),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.enabled && widget.onPressed != null
              ? _handleTap
              : null,
          onTapDown: widget.enabled ? (_) => _setPressed(true) : null,
          onTapUp: widget.enabled ? (_) => _setPressed(false) : null,
          onTapCancel: widget.enabled ? () => _setPressed(false) : null,
          child: widget.child(context, _controller, _pressed),
        ),
      ),
    );
  }
}
