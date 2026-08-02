import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class LoadingPathIndicator extends StatefulWidget {
  const LoadingPathIndicator({super.key, this.color = AppColors.pathStart});

  final Color color;

  @override
  State<LoadingPathIndicator> createState() => _LoadingPathIndicatorState();
}

class _LoadingPathIndicatorState extends State<LoadingPathIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppSizes.loadingIndicatorPeriod,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.loadingIndicatorWidth,
      height: AppSizes.loadingIndicatorHeight,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _PathPainter(
              progress: _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _PathPainter extends CustomPainter {
  _PathPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  static const double _trackStrokeWidth = 1.4;
  static const double _trackAlpha = 0.25;
  static const double _glowBlur = 6;
  static const double _glowAlpha = 0.35;
  static const double _glowRadius = 6;
  static const double _coreRadius = 2.6;
  static const double _baseYMul = 0.55;
  static const double _ctrlYMul = 0.7;
  static const double _ctrlX1Mul = 0.25;
  static const double _ctrlX2Mul = 0.5;
  static const double _edgeInset = 4;

  final Paint _trackPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = _trackStrokeWidth
    ..strokeCap = StrokeCap.round;
  final Paint _glowPaint = Paint()
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, _glowBlur);
  final Paint _corePaint = Paint();

  Path? _path;
  PathMetric? _metric;
  Size _cachedSize = Size.zero;

  @override
  void paint(Canvas canvas, Size size) {
    if (_path == null || _cachedSize != size) {
      _cachedSize = size;
      final baseY = size.height * _baseYMul;
      _path = Path()
        ..moveTo(_edgeInset, baseY)
        ..cubicTo(
          size.width * _ctrlX1Mul,
          baseY - size.height * _ctrlYMul,
          size.width * _ctrlX2Mul,
          baseY + size.height * _ctrlYMul,
          size.width - _edgeInset,
          baseY,
        );
      _metric = _path!.computeMetrics().first;
    }

    _trackPaint.color = color.withValues(alpha: _trackAlpha);
    canvas.drawPath(_path!, _trackPaint);

    final tangent = _metric!.getTangentForOffset(_metric!.length * progress);
    if (tangent == null) return;

    _glowPaint.color = color.withValues(alpha: _glowAlpha);
    canvas.drawCircle(tangent.position, _glowRadius, _glowPaint);
    _corePaint.color = color;
    canvas.drawCircle(tangent.position, _coreRadius, _corePaint);
  }

  @override
  bool shouldRepaint(covariant _PathPainter old) =>
      old.progress != progress || old.color != color;
}
