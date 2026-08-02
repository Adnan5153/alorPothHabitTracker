import 'package:flutter/material.dart';

import '../../../extensions/build_context_extensions.dart';
import '../../../liquidGlass/effects/liquid_glass_effect.dart';
import '../../../liquidGlass/theme/liquid_theme.dart';
import '../../../liquidGlass/transitions/liquid_transition.dart';
import '../glass_container/exports.dart';
import 'constants.dart';
import 'models.dart';

/// Reusable Liquid Glass content surface with title, subtitle, leading,
/// trailing, body and footer composition slots.
class GlassCard extends StatefulWidget {
  const GlassCard({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.body,
    this.footer,
    this.size = GlassSize.medium,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.enabled = true,
    this.padding,
    this.margin,
    this.borderRadius,
    this.tier = GlassTier.standard,
    this.tint,
    this.borderColor,
  });

  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget? body;
  final Widget? footer;
  final GlassSize size;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool selected;
  final bool enabled;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final GlassTier tier;
  final Color? tint;
  final Color? borderColor;

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _hovered = false;
  bool _pressed = false;

  bool get _hasInteraction =>
      widget.enabled && (widget.onTap != null || widget.onLongPress != null);

  void _setHovered(bool value) {
    if (!_hasInteraction || _hovered == value) return;
    setState(() => _hovered = value);
  }

  void _setPressed(bool value) {
    if (!_hasInteraction || _pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = LiquidThemes.of(context);
    final scheme = Theme.of(context).colorScheme;
    final effectiveSize = widget.size.forContext(context);
    final metrics = GlassCardMetrics.of(effectiveSize);
    final radius = widget.borderRadius ?? metrics.borderRadius;
    final disabled = !widget.enabled;
    final foreground = disabled
        ? scheme.onSurface.withValues(
            alpha: GlassCardConstants.disabledContentAlpha,
          )
        : scheme.onSurface;
    final baseColor = widget.tint ?? theme.surfaceTint;
    final border = widget.borderColor ??
        (widget.selected ? scheme.primary : theme.borderColor);

    final card = LiquidGlassEffect(
      baseColor: baseColor,
      blurStrength: _blurForTier(theme, widget.tier),
      surfaceOpacity: disabled
          ? theme.surfaceOpacity * 0.55
          : widget.selected
              ? theme.surfaceOpacity * 1.15
              : theme.surfaceOpacity,
      reflectionIntensity: disabled
          ? theme.reflectionIntensity * 0.45
          : theme.reflectionIntensity,
      borderColor: border,
      borderWidth: GlassCardConstants.borderWidth,
      borderRadius: radius.topLeft.x,
      margin: widget.margin is EdgeInsets ? widget.margin as EdgeInsets? : null,
      boxShadow: _hovered && !disabled
          ? [
              BoxShadow(
                color: scheme.shadow.withValues(alpha: 0.16),
                blurRadius: 18,
                offset: const Offset(0, 4),
              ),
            ]
          : null,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: GlassCardConstants.minHeight,
        ),
        child: Padding(
          padding: widget.padding ?? metrics.padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.leading != null ||
                  widget.title != null ||
                  widget.subtitle != null ||
                  widget.trailing != null)
                _Header(
                  leading: widget.leading,
                  trailing: widget.trailing,
                  title: widget.title,
                  subtitle: widget.subtitle,
                  titleSize: metrics.titleSize,
                  titleColor: foreground,
                ),
              if (widget.body != null) ...[
                const SizedBox(height: GlassCardConstants.bodyGap),
                DefaultTextStyle.merge(
                  style: context.textStyles.bodyMedium ?? const TextStyle(),
                  child: IconTheme.merge(
                    data: IconThemeData(color: foreground, size: 18),
                    child: widget.body!,
                  ),
                ),
              ],
              if (widget.footer != null) ...[
                const SizedBox(height: GlassCardConstants.footerGap),
                DefaultTextStyle.merge(
                  style: context.textStyles.bodySmall ?? const TextStyle(),
                  child: widget.footer!,
                ),
              ],
            ],
          ),
        ),
      ),
    );

    final interactive = LiquidPressController(
      enabled: _hasInteraction,
      child: (context, animation, _) => LiquidTransition(
        animation: animation,
        beginScale: GlassCardConstants.pressScale,
        fade: false,
        child: card,
      ),
    );

    return MouseRegion(
      cursor: _hasInteraction
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => _setHovered(true),
      onExit: (_) {
        _setHovered(false);
        _setPressed(false);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: _hasInteraction ? widget.onTap : null,
        onLongPress: _hasInteraction ? widget.onLongPress : null,
        child: Semantics(
          button: _hasInteraction,
          enabled: widget.enabled,
          selected: widget.selected,
          label: widget.title,
          child: IgnorePointer(
            ignoring: disabled,
            child: interactive,
          ),
        ),
      ),
    );
  }

  double _blurForTier(LiquidTheme theme, GlassTier tier) {
    return switch (tier) {
      GlassTier.subtle => theme.blurStrength * 0.65,
      GlassTier.standard => theme.blurStrength,
      GlassTier.bold => theme.blurStrength * 1.25,
      GlassTier.popup => theme.blurStrength * 1.1,
    };
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.leading,
    required this.trailing,
    required this.title,
    required this.subtitle,
    required this.titleSize,
    required this.titleColor,
  });

  final Widget? leading;
  final Widget? trailing;
  final String? title;
  final String? subtitle;
  final double titleSize;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    final hasTitle = title != null || subtitle != null;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leading != null)
          SizedBox(
            width: GlassCardConstants.leadingSize,
            height: GlassCardConstants.leadingSize,
            child: leading!,
          ),
        if (leading != null && hasTitle)
          const SizedBox(width: GlassCardConstants.headerGap + 8),
        Expanded(
          child: hasTitle
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                        ),
                      ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: GlassCardConstants.subtitleSize,
                            height: GlassCardConstants.subtitleLineHeight,
                            color: titleColor.withValues(alpha: 0.72),
                          ),
                        ),
                      ),
                  ],
                )
              : const SizedBox.shrink(),
        ),
        if (trailing != null && hasTitle)
          const SizedBox(width: GlassCardConstants.headerGap + 8),
        if (trailing != null)
          SizedBox(
            width: GlassCardConstants.trailingSize,
            height: GlassCardConstants.trailingSize,
            child: trailing!,
          ),
      ],
    );
  }
}