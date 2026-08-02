import 'package:flutter/material.dart';

import '../../liquidGlass/exports.dart';
import 'app_bar_constants.dart';

/// Circular avatar used as a leading widget, typically for the active user's
/// profile or a dashboard identity marker.
class AppBarAvatar extends StatelessWidget {
  const AppBarAvatar({
    super.key,
    this.imageUrl,
    this.fallbackIcon = Icons.person_rounded,
    this.onPressed,
    this.tooltip,
    this.heroTag,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String? imageUrl;
  final IconData fallbackIcon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Object? heroTag;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = AppBarSizes.avatarRadius;
    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? scheme.primaryContainer,
      foregroundColor: foregroundColor ?? scheme.onPrimaryContainer,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null ? Icon(fallbackIcon) : null,
    );

    final wrapped =
        heroTag != null ? Hero(tag: heroTag!, child: avatar) : avatar;

    final content = LiquidTapSurface(
      tooltip: tooltip ?? 'Profile',
      semanticLabel: tooltip ?? 'Profile',
      onTap: onPressed,
      padding: const EdgeInsets.all(6),
      borderRadius: BorderRadius.circular(radius + 6),
      child: wrapped,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppBarSizes.titleHorizontalPadding,
      ),
      child: content,
    );
  }
}
