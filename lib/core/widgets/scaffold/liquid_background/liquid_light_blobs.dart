import 'dart:ui' as ui;

import 'package:flutter/material.dart';

@immutable
class LiquidBlobSpec {
  const LiquidBlobSpec({
    required this.center,
    required this.radius,
    required this.opacity,
  });

  final Offset center;
  final double radius;
  final double opacity;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LiquidBlobSpec &&
          center == other.center &&
          radius == other.radius &&
          opacity == other.opacity;

  @override
  int get hashCode => Object.hash(center, radius, opacity);
}

/// Paints soft radial-gradient circles. Lives outside any Widget so it
/// can mount inside a `RepaintBoundary` driven by an `AnimatedBuilder`
/// for cheap per-frame work.
class LiquidLightBlobsPainter extends CustomPainter {
  const LiquidLightBlobsPainter({
    required this.blobs,
    required this.tint,
    this.maxBlurSigma = 0,
  });

  final List<LiquidBlobSpec> blobs;
  final Color tint;
  final double maxBlurSigma;

  @override
  void paint(Canvas canvas, Size size) {
    final blurSigma = maxBlurSigma > 0 ? maxBlurSigma : 0.0;
    for (final blob in blobs) {
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            tint.withValues(alpha: blob.opacity),
            tint.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 1.0],
        ).createShader(
          Rect.fromCircle(center: blob.center, radius: blob.radius),
        );
      if (blurSigma > 0) {
        paint.imageFilter =
            ui.ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma);
      }
      canvas.drawCircle(blob.center, blob.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant LiquidLightBlobsPainter oldDelegate) {
    if (oldDelegate.tint != tint) return true;
    if (oldDelegate.maxBlurSigma != maxBlurSigma) return true;
    if (oldDelegate.blobs.length != blobs.length) return true;
    for (var i = 0; i < blobs.length; i++) {
      if (oldDelegate.blobs[i] != blobs[i]) return true;
    }
    return false;
  }
}
