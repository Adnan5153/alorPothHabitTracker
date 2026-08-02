import 'package:flutter/material.dart';

import '../liquid_scaffold_extensions/liquid_scaffold_context_extensions.dart';

/// Overlay slot. When `scrim` is true the overlay sits above an
/// opaque scrim that absorbs taps; otherwise it just paints above the
/// body without affecting layout.
class LiquidOverlay extends StatelessWidget {
  const LiquidOverlay({
    super.key,
    required this.child,
    this.scrim = false,
    this.scrimColor,
  });

  final Widget child;
  final bool scrim;
  final Color? scrimColor;

  @override
  Widget build(BuildContext context) {
    if (!scrim) return Positioned.fill(child: child);
    final tokens = context.liquidScaffoldTheme;
    final base = scrimColor ?? Colors.black;
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned.fill(
            child: AbsorbPointer(
              absorbing: true,
              child: ColoredBox(
                color: base.withValues(alpha: tokens.overlayScrimOpacity),
              ),
            ),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}