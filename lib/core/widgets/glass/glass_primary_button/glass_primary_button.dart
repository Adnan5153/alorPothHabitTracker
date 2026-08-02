import 'package:flutter/material.dart';

import '../glass_container/exports.dart';
import 'constants.dart';
import 'models.dart';

/// Premium call-to-action button with a glass-tinted fill, animated press
/// feedback, ripple, leading/trailing icons, loading state, and adaptive
/// sizing. Designed to replace [PrimaryButton] anywhere a higher-emphasis
/// surface is desired.
class GlassPrimaryButton extends StatefulWidget {
  const GlassPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.size = GlassSize.medium,
    this.isLoading = false,
    this.isExpanded = true,
    this.leadingIcon,
    this.trailingIcon,
    this.gradient,
    this.semanticLabel,
    this.compact = false,
    this.borderRadius,
  });

  final String label;
  final VoidCallback? onPressed;
  final GlassSize size;
  final bool isLoading;
  final bool isExpanded;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Gradient? gradient;
  final String? semanticLabel;
  final bool compact;
  final BorderRadius? borderRadius;

  @override
  State<GlassPrimaryButton> createState() => _GlassPrimaryButtonState();
}

class _GlassPrimaryButtonState extends State<GlassPrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final palette = GlassPalette.of(context);
    final isDisabled = widget.isLoading || widget.onPressed == null;
    final effectiveSize =
        (widget.compact ? GlassSize.small : widget.size).forContext(context);
    final metrics = GlassPrimaryButtonMetrics.of(effectiveSize);

    final foreground = isDisabled ? palette.disabled : palette.onAccent;
    final fill = isDisabled
        ? palette.foreground.withValues(alpha: 0.10)
        : (palette.accent);

    final gradient = widget.gradient ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            fill.withValues(alpha: 0.95),
            fill.withValues(alpha: 0.78),
          ],
        );

    final button = AnimatedScale(
      scale: _pressed && !isDisabled
          ? GlassPrimaryButtonConstants.pressScale
          : 1.0,
      duration: GlassPrimaryButtonConstants.tapFeedback,
      curve: Curves.easeInOut,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: isDisabled ? null : widget.onPressed,
          onTapDown: (_) {
            if (!isDisabled) setState(() => _pressed = true);
          },
          onTapUp: (_) {
            if (!isDisabled) setState(() => _pressed = false);
          },
          onTapCancel: () {
            if (!isDisabled) setState(() => _pressed = false);
          },
          borderRadius:
              widget.borderRadius ?? BorderRadius.circular(GlassConstants.radiusLg),
          splashColor: Colors.white.withValues(alpha: 0.18),
          highlightColor: Colors.white.withValues(alpha: 0.10),
          child: Ink(
            decoration: BoxDecoration(
              gradient: isDisabled ? null : gradient,
              color: isDisabled ? null : null,
              borderRadius:
                  widget.borderRadius ?? BorderRadius.circular(GlassConstants.radiusLg),
              boxShadow: isDisabled
                  ? null
                  : [
                      BoxShadow(
                        color: fill.withValues(alpha: 0.30),
                        blurRadius: GlassConstants.shadowBlurMedium,
                        offset: const Offset(0, 6),
                      ),
                    ],
              border: Border.all(
                color: Colors.white.withValues(
                  alpha: isDisabled ? 0.18 : 0.35,
                ),
                width: GlassConstants.borderThin,
              ),
            ),
            child: Container(
              constraints: const BoxConstraints(
                minHeight: GlassPrimaryButtonConstants.minTouchTarget,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: GlassPrimaryButtonConstants.padH,
                vertical: metrics.verticalPadding,
              ),
              alignment: Alignment.center,
              child: AnimatedSwitcher(
                duration: GlassConstants.animMicro,
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: _buildContent(foreground, metrics, fill),
              ),
            ),
          ),
        ),
      ),
    );

    final wrapped = Semantics(
      label: widget.semanticLabel ?? widget.label,
      button: true,
      enabled: !isDisabled,
      child: button,
    );

    if (widget.isExpanded) {
      return SizedBox(width: double.infinity, child: wrapped);
    }
    return wrapped;
  }

  Widget _buildContent(
    Color foreground,
    GlassPrimaryButtonMetrics metrics,
    Color accent,
  ) {
    if (widget.isLoading) {
      return SizedBox(
        key: const ValueKey('glass-button-loading'),
        height: GlassPrimaryButtonConstants.loadingSize,
        width: GlassPrimaryButtonConstants.loadingSize,
        child: CircularProgressIndicator(
          strokeWidth: GlassPrimaryButtonConstants.loadingStroke,
          valueColor: AlwaysStoppedAnimation<Color>(foreground),
        ),
      );
    }

    final text = Text(
      widget.label,
      key: const ValueKey('glass-button-label'),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: foreground,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );

    if (widget.leadingIcon == null && widget.trailingIcon == null) {
      return text;
    }

    return Row(
      key: const ValueKey('glass-button-icon-label'),
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.leadingIcon != null) ...[
          Icon(widget.leadingIcon, size: metrics.iconSize, color: foreground),
          const SizedBox(width: GlassPrimaryButtonConstants.iconLabelGap),
        ],
        text,
        if (widget.trailingIcon != null) ...[
          const SizedBox(width: GlassPrimaryButtonConstants.iconLabelGap),
          Icon(widget.trailingIcon, size: metrics.iconSize, color: foreground),
        ],
      ],
    );
  }
}