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

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions = const <Widget>[],
    this.centerTitle,
    this.showBackButton,
    this.backgroundColor,
    this.gradient,
    this.elevation,
    this.borderRadius,
    this.height,
    this.padding,
    this.heroTag,
    this.titleStyle,
    this.subtitleStyle,
    this.variant = AppBarVariant.defaultBar,
    this.transparent = false,
    this.showShadow = true,
    this.safeArea = false,
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
  final bool? centerTitle;
  final bool? showBackButton;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double? elevation;
  final BorderRadius? borderRadius;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Object? heroTag;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final AppBarVariant variant;
  final bool transparent;
  final bool showShadow;
  final bool safeArea;
  final bool showSearch;
  final bool showNotification;
  final bool showTheme;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onNotificationPressed;
  final ValueChanged<ThemeMode>? onThemeChanged;
  final int notificationCount;
  final ThemeMode? themeMode;

  @override
  Size get preferredSize => Size.fromHeight(height ?? AppBarSizes.toolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colors = AppBarColorsRuntime.of(context);
    final isTransparent = transparent || variant.transparent;
    final isGradient = gradient != null || variant.gradient;
    final center = centerTitle ?? variant.centerTitle;
    final showBack = showBackButton ?? variant.showBackButton;
    final tHeight = height ?? context.appBarHeight;
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
        (showBack
            ? AppBarBackButton(color: colors.foreground)
            : (variant.showAvatar
                ? const AppBarAvatar(tooltip: 'Profile')
                : null));

    final toolbar = SizedBox(
      height: tHeight,
      child: Padding(
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: AppBarSizes.titleHorizontalPadding,
            ),
        child: Row(
          children: [
            ?leadingWidget,
            Expanded(
              child: _TitleArea(
                title: title,
                subtitle: subtitle,
                centerTitle: center,
                titleStyle: titleStyle,
                subtitleStyle: subtitleStyle,
                heroTag: heroTag,
              ),
            ),
            if (trailing.isNotEmpty)
              Row(
                children: [
                  for (int i = 0; i < trailing.length; i++) ...[
                    if (i > 0)
                      const SizedBox(width: AppBarSizes.actionSpacing / 2),
                    trailing[i],
                  ],
                ],
              ),
          ],
        ),
      ),
    );

    final hasRadius = borderRadius != null;
    final useGlass = !isTransparent && !isGradient;

    if (useGlass) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: LiquidGlassContainer(
          blur: 18,
          opacity: LiquidThemes.of(context).surfaceOpacity,
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          child: Container(
            decoration: (showShadow && !isTransparent)
                ? BoxDecoration(
                    borderRadius: borderRadius ?? BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: colors.foreground.withValues(alpha: 0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  )
                : null,
            child: ColoredBox(
              color: bg,
              child: safeArea ? SafeArea(bottom: false, child: toolbar) : toolbar,
            ),
          ),
        ),
      );
    }

    return Material(
      type: MaterialType.transparency,
      elevation: elevation ?? 0,
      borderRadius: borderRadius ?? BorderRadius.zero,
      clipBehavior: hasRadius ? Clip.antiAlias : Clip.none,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isGradient ? null : Colors.transparent,
          gradient: isGradient ? (gradient ?? _defaultGradient(colors)) : null,
          borderRadius: borderRadius,
          boxShadow: (showShadow && !isTransparent)
              ? [
                  BoxShadow(
                    color: colors.foreground.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: safeArea ? SafeArea(bottom: false, child: toolbar) : toolbar,
      ),
    );
  }

  Gradient _defaultGradient(AppBarColorsRuntime colors) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [colors.primary, colors.primary.withValues(alpha: 0.78)],
    );
  }
}

class _TitleArea extends StatelessWidget {
  const _TitleArea({
    required this.title,
    required this.subtitle,
    required this.centerTitle,
    required this.titleStyle,
    required this.subtitleStyle,
    required this.heroTag,
  });

  final String? title;
  final String? subtitle;
  final bool centerTitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    if (title == null && heroTag == null && subtitle == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppBarSizes.titleHorizontalPadding,
      ),
      child: Align(
        alignment: centerTitle ? Alignment.center : Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            if (title != null)
              AppBarTitle(title!, style: titleStyle)
            else if (heroTag != null)
              Hero(tag: heroTag!, child: const SizedBox.shrink()),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: AppBarSubtitle(subtitle!, style: subtitleStyle),
              ),
          ],
        ),
      ),
    );
  }
}
