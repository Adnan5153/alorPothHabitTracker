import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../liquidGlass/effects/liquid_glass_effect.dart';
import '../../../liquidGlass/theme/liquid_theme.dart';
import '../../../liquidGlass/transitions/liquid_transition.dart';
import '../glass_container/exports.dart';
import 'constants.dart';

/// Reusable Liquid Glass dropdown list surface. Renders a scrollable,
/// responsive list of selectable rows with empty / loading slots and
/// delegates rendering to the Liquid Glass framework.
class GlassDropdownContainer extends StatelessWidget {
  const GlassDropdownContainer({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.maxHeight,
    this.minHeight,
    this.padding,
    this.borderRadius,
    this.tier = GlassTier.popup,
    this.isLoading = false,
    this.empty,
    this.borderColor,
    this.selectedIndex,
    this.onItemSelected,
    this.tint,
    this.gradient,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double? maxHeight;
  final double? minHeight;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final GlassTier tier;
  final bool isLoading;
  final Widget? empty;
  final Color? borderColor;
  final int? selectedIndex;
  final ValueChanged<int>? onItemSelected;
  final Color? tint;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final theme = LiquidThemes.of(context);
    final radius = borderRadius ?? BorderRadius.circular(theme.borderRadius);
    final resolvedPadding = padding ??
        const EdgeInsets.symmetric(
          vertical: GlassDropdownContainerConstants.padV,
        );

    Widget body = _body(context, resolvedPadding);

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? GlassDropdownContainerConstants.maxHeight,
        minHeight: minHeight ?? 0,
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: LiquidGlassEffect(
          baseColor: tint ?? theme.surfaceTint,
          borderColor: borderColor ?? theme.borderColor,
          borderRadius: radius.topLeft.x,
          borderWidth: GlassDropdownContainerConstants.borderWidth,
          blurStrength: theme.blurStrength * _tierBlurMultiplier(tier),
          surfaceOpacity: theme.surfaceOpacity * _tierOpacityMultiplier(tier),
          reflectionIntensity:
              theme.reflectionIntensity * _tierBorderMultiplier(tier),
          child: ClipRRect(
            borderRadius: radius,
            child: body,
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: GlassDropdownContainerConstants.openAnim,
          curve: GlassDropdownContainerConstants.openCurve,
        )
        .slideY(
          begin: GlassDropdownContainerConstants.openSlideY,
          end: 0,
          duration: GlassDropdownContainerConstants.openAnim,
          curve: GlassDropdownContainerConstants.openCurve,
        )
        .scale(
          begin: const Offset(
            GlassDropdownContainerConstants.openScale,
            GlassDropdownContainerConstants.openScale,
          ),
          end: const Offset(1, 1),
          duration: GlassDropdownContainerConstants.openAnim,
          curve: GlassDropdownContainerConstants.openCurve,
        );
  }

  Widget _body(BuildContext context, EdgeInsetsGeometry resolvedPadding) {
    if (isLoading) {
      return SizedBox(
        height: GlassDropdownContainerConstants.loadingHeight,
        child: const Center(child: _LoadingIndicator()),
      );
    }

    if (itemCount == 0) {
      return SizedBox(
        height: GlassDropdownContainerConstants.emptyHeight,
        child: Center(
          child: empty ??
              Text(
                'কোনো ফলাফল নেই',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
        ),
      );
    }

    return Scrollbar(
      thumbVisibility: false,
      child: LiquidTransition(
        animation: const AlwaysStoppedAnimation<double>(1),
        beginScale: 0.99,
        fade: true,
        child: ListView.builder(
          padding: resolvedPadding,
          shrinkWrap: true,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            final selected = selectedIndex == index;
            return _ItemRow(
              selected: selected,
              onTap: onItemSelected == null ? null : () => onItemSelected!(index),
              child: itemBuilder(context, index),
            );
          },
        ),
      ),
    );
  }

  double _tierBlurMultiplier(GlassTier tier) => switch (tier) {
        GlassTier.subtle => 0.7,
        GlassTier.standard => 0.95,
        GlassTier.bold => 1.25,
        GlassTier.popup => 1.15,
      };

  double _tierOpacityMultiplier(GlassTier tier) => switch (tier) {
        GlassTier.subtle => 0.7,
        GlassTier.standard => 0.95,
        GlassTier.bold => 1.2,
        GlassTier.popup => 1.15,
      };

  double _tierBorderMultiplier(GlassTier tier) => switch (tier) {
        GlassTier.subtle => 0.7,
        GlassTier.standard => 0.95,
        GlassTier.bold => 1.05,
        GlassTier.popup => 1.0,
      };
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({
    required this.selected,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = GlassPalette.of(context);
    final highlight = palette.accent.withValues(
      alpha: selected
          ? GlassDropdownContainerConstants.highlightAlpha
          : GlassDropdownContainerConstants.highlightBaseAlpha,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: GlassDropdownContainerConstants.itemHorizontalPadding,
        vertical:
            GlassDropdownContainerConstants.itemVerticalPadding /
                2,
      ),
      child: LiquidTransition(
        animation: const AlwaysStoppedAnimation<double>(1),
        beginScale: 0.98,
        fade: true,
        child: Container(
          decoration: BoxDecoration(
            color: highlight,
            borderRadius:
                BorderRadius.circular(GlassDropdownContainerConstants.itemGap * 3),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
              borderRadius:
                  BorderRadius.circular(GlassDropdownContainerConstants.itemGap * 3),
              splashColor: palette.foreground.withValues(alpha: 0.06),
              highlightColor: palette.foreground.withValues(alpha: 0.04),
              child: IconTheme.merge(
                data: IconThemeData(
                  color: selected ? palette.accent : palette.foreground,
                  size: GlassDropdownContainerConstants.itemIconSize,
                ),
                child: DefaultTextStyle.merge(
                  style: TextStyle(
                    color: selected ? palette.accent : palette.foreground,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: CircularProgressIndicator(strokeWidth: 2.2),
    );
  }
}