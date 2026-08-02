import 'package:flutter/material.dart';

import '../../liquidGlass/exports.dart';
import 'app_bar_avatar.dart';
import 'app_bar_back_button.dart';
import 'app_bar_colors_runtime.dart';
import 'app_bar_constants.dart';
import 'app_bar_extensions.dart';
import 'app_bar_notification_button.dart';
import 'app_bar_search_button.dart';
import 'app_bar_theme_button.dart';
import 'app_bar_title.dart';

/// Sliver counterpart of [CustomAppBar]. Drives collapsing-toolbar surfaces,
/// large-title headers, parallax backgrounds, and stretch-on-over-scroll
/// gestures while delegating all chrome (leading, title, actions) to the
/// shared building blocks.
class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions = const <Widget>[],
    this.pinned = true,
    this.floating = false,
    this.snap = false,
    this.stretch = false,
    this.centerTitle,
    this.expandedHeight,
    this.collapsedHeight,
    this.gradient,
    this.backgroundColor,
    this.backgroundImage,
    this.flexibleSpace,
    this.largeTitle,
    this.variant = AppBarVariant.defaultBar,
    this.heroTag,
    this.showShadow = true,
    this.elevation,
    this.showSearch = false,
    this.showNotification = false,
    this.showTheme = false,
    this.onSearchPressed,
    this.onNotificationPressed,
    this.onThemeChanged,
    this.notificationCount = 0,
    this.themeMode,
  });

  final String? title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;
  final bool pinned;
  final bool floating;
  final bool snap;
  final bool stretch;
  final bool? centerTitle;
  final double? expandedHeight;
  final double? collapsedHeight;
  final Gradient? gradient;
  final Color? backgroundColor;
  final ImageProvider? backgroundImage;
  final Widget? flexibleSpace;
  final String? largeTitle;
  final AppBarVariant variant;
  final Object? heroTag;
  final bool showShadow;
  final double? elevation;
  final bool showSearch;
  final bool showNotification;
  final bool showTheme;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onNotificationPressed;
  final ValueChanged<ThemeMode>? onThemeChanged;
  final int notificationCount;
  final ThemeMode? themeMode;

  @override
  Widget build(BuildContext context) {
    final colors = AppBarColorsRuntime.of(context);
    final isGradient = gradient != null || variant.gradient;
    final isTransparent = variant.transparent;
    final center = centerTitle ?? variant.centerTitle;
    final expanded = expandedHeight ?? variant.expandedHeight;
    final collapsed = collapsedHeight ?? AppBarSizes.collapsedHeight;
    final bg = backgroundColor ?? colors.background;

    final trailing = <Widget>[
      ...actions,
      if (showSearch || variant.showSearch)
        AppBarSearchButton(
          onPressed: onSearchPressed,
          isActive: variant == AppBarVariant.search,
        ),
      if (showNotification || variant.showNotification)
        AppBarNotificationButton(
          onPressed: onNotificationPressed,
          count: notificationCount,
        ),
      if ((showTheme || variant.showTheme) &&
          themeMode != null &&
          onThemeChanged != null)
        AppBarThemeButton(mode: themeMode!, onChanged: onThemeChanged!),
    ];

    final leadingWidget = leading ??
        (variant.showBackButton
            ? AppBarBackButton(color: colors.foreground)
            : (variant.showAvatar
                ? const AppBarAvatar(tooltip: 'Profile')
                : null));

    final effectiveTitle = largeTitle != null
        ? AppBarLargeTitle(largeTitle!)
        : (title != null ? AppBarTitle(title!) : null);

    return SliverAppBar(
      pinned: pinned || variant.pinned,
      floating: floating || variant.floating,
      snap: snap || variant.snap,
      stretch: stretch || variant.stretch,
      centerTitle: center,
      expandedHeight: largeTitle != null ? expanded : null,
      collapsedHeight: collapsed,
      backgroundColor: isGradient || isTransparent
          ? Colors.transparent
          : bg,
      foregroundColor: colors.foreground,
      surfaceTintColor: Colors.transparent,
      shadowColor: showShadow
          ? colors.foreground.withValues(alpha: 0.05)
          : Colors.transparent,
      elevation: 0,
      leading: leadingWidget,
      title: effectiveTitle,
      actions: trailing,
      flexibleSpace: flexibleSpace ??
          _DefaultFlexibleSpace(
            isGradient: isGradient,
            gradient: gradient,
            backgroundImage: backgroundImage,
            largeTitle: largeTitle,
            subtitle: subtitle,
            heroTag: heroTag,
            foreground: colors.foreground,
            primary: colors.primary,
            useGlass: !isGradient && !isTransparent,
            backgroundColor: bg,
          ),
    );
  }
}

class _DefaultFlexibleSpace extends StatelessWidget {
  const _DefaultFlexibleSpace({
    required this.isGradient,
    required this.gradient,
    required this.backgroundImage,
    required this.largeTitle,
    required this.subtitle,
    required this.heroTag,
    required this.foreground,
    required this.primary,
    required this.useGlass,
    required this.backgroundColor,
  });

  final bool isGradient;
  final Gradient? gradient;
  final ImageProvider? backgroundImage;
  final String? largeTitle;
  final String? subtitle;
  final Object? heroTag;
  final Color foreground;
  final Color primary;
  final bool useGlass;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    if (largeTitle == null &&
        !isGradient &&
        backgroundImage == null &&
        !useGlass) {
      return const SizedBox.shrink();
    }

    Widget content = Stack(
      fit: StackFit.expand,
      children: [
        if (useGlass)
          ColoredBox(color: backgroundColor)
        else if (isGradient)
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: gradient ??
                  LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primary, primary.withValues(alpha: 0.78)],
                  ),
            ),
          ),
        if (backgroundImage != null)
          DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: backgroundImage!,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  foreground.withValues(alpha: 0.20),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
        if (largeTitle != null)
          Positioned(
            left: 56,
            right: 56,
            bottom: 16,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (heroTag != null)
                    Hero(tag: heroTag!, child: AppBarLargeTitle(largeTitle!))
                  else
                    AppBarLargeTitle(largeTitle!),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    AppBarSubtitle(subtitle!),
                  ],
                ],
              ),
            ),
          ),
      ],
    );

    if (useGlass) {
      content = LiquidGlassContainer(
        blur: 18,
        opacity: LiquidThemes.of(context).surfaceOpacity,
        borderRadius: BorderRadius.zero,
        child: content,
      );
    }

    return content;
  }
}
