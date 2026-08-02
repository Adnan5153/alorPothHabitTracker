import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../liquidGlass/theme/liquid_theme.dart';
import '../liquid_scaffold_extensions/liquid_scaffold_context_extensions.dart';
import 'liquid_background_constants.dart';
import 'liquid_light_blobs.dart';

/// Self-contained background layer. Paints (from back to front):
///
/// 1. A solid theme colour so the page never paints Material grey.
/// 2. An optional gradient (when `gradient` is supplied).
/// 3. An optional image, blurred through `ImageFiltered` when
///    `blurImage` is true.
/// 4. An optional set of ambient light blobs driven by an internal
///    `AnimationController` (only mounted when `ambient.enabled`).
///
/// `background: Widget?` is an escape hatch — when supplied, it replaces
/// every other layer above.
class LiquidBackground extends StatefulWidget {
  const LiquidBackground({
    super.key,
    this.background,
    this.gradient,
    this.image,
    this.imageFit = BoxFit.cover,
    this.blurImage = false,
    this.ambient = const AmbientBackgroundStyle(),
  });

  final Widget? background;
  final Gradient? gradient;
  final ImageProvider? image;
  final BoxFit imageFit;
  final bool blurImage;
  final AmbientBackgroundStyle ambient;

  @override
  State<LiquidBackground> createState() => _LiquidBackgroundState();
}

class _LiquidBackgroundState extends State<LiquidBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.ambient.duration,
    );
    if (widget.ambient.enabled && widget.background == null) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant LiquidBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    final wasEnabled = oldWidget.ambient.enabled;
    final isEnabled = widget.ambient.enabled;
    if (wasEnabled != isEnabled) {
      if (isEnabled && widget.background == null) {
        _controller
          ..duration = widget.ambient.duration
          ..repeat(reverse: true);
      } else {
        _controller.stop();
      }
    } else if (isEnabled &&
        widget.ambient.duration != oldWidget.ambient.duration) {
      _controller
        ..stop()
        ..duration = widget.ambient.duration
        ..repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<LiquidBlobSpec> _buildBlobs(Size size, double value) {
    final tokens = context.liquidScaffoldTheme;
    final maxRadius =
        math.min(size.width, size.height) * tokens.ambientBlobMaxRadiusFraction;
    final count = tokens.ambientBlobCount;
    final result = <LiquidBlobSpec>[];
    for (var i = 0; i < count; i++) {
      final phase = (i / count) * 2 * math.pi;
      final theta = (value * 2 * math.pi) + phase;
      final center = Offset(
        size.width * (0.5 + 0.30 * math.cos(theta)),
        size.height * (0.5 + 0.30 * math.sin(theta)),
      );
      final radius = maxRadius * (0.6 + 0.4 * math.sin(theta * 0.7));
      final opacity =
          tokens.ambientBlobOpacityMin +
              (tokens.ambientBlobOpacityMax - tokens.ambientBlobOpacityMin) *
                  (0.5 + 0.5 * math.sin(theta * 1.1));
      result.add(LiquidBlobSpec(
        center: center,
        radius: radius,
        opacity: opacity.clamp(0.0, 1.0),
      ));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.background != null) return widget.background!;

    final theme = LiquidThemes.of(context);
    final tokens = context.liquidScaffoldTheme;
    final baseColor = theme.brightness == Brightness.dark
        ? Theme.of(context).scaffoldBackgroundColor
        : theme.backgroundColor;

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: baseColor),
        if (widget.gradient != null)
          DecoratedBox(
            decoration: BoxDecoration(gradient: widget.gradient),
          ),
        if (widget.image != null)
          ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: widget.blurImage ? tokens.imageBlurSigma : 0,
              sigmaY: widget.blurImage ? tokens.imageBlurSigma : 0,
            ),
            child: Image(
              image: widget.image!,
              fit: widget.imageFit,
              gaplessPlayback: true,
            ),
          ),
        if (widget.ambient.enabled)
          LayoutBuilder(
            builder: (context, constraints) {
              final size = Size(constraints.maxWidth, constraints.maxHeight);
              return RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: LiquidLightBlobsPainter(
                        tint: widget.ambient.tint ??
                            theme.lightReflectionColor,
                        maxBlurSigma: tokens.ambientBlobMaxBlurSigma,
                        blobs: _buildBlobs(size, _controller.value),
                      ),
                    );
                  },
                ),
              );
            },
          ),
      ],
    );
  }
}