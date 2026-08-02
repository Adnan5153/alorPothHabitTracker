import 'package:flutter/material.dart';

/// Edge-aware SafeArea tuned for the Alor Poth design system. Defaults to
/// protecting every edge. `color` defaults to `Colors.transparent` so the
/// scaffold never paints an opaque Material slab on top of the
/// `LiquidBackground` layer.
class LiquidSafeArea extends StatelessWidget {
  const LiquidSafeArea({
    super.key,
    required this.child,
    this.top = true,
    this.bottom = true,
    this.left = true,
    this.right = true,
    this.color,
    this.minimum = EdgeInsets.zero,
  });

  final Widget child;
  final bool top;
  final bool bottom;
  final bool left;
  final bool right;
  final Color? color;
  final EdgeInsets minimum;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      minimum: minimum,
      child: ColoredBox(
        color: color ?? Colors.transparent,
        child: child,
      ),
    );
  }
}
