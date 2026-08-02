import 'package:flutter/material.dart';

import 'app_bar_action_button.dart';
import 'app_bar_constants.dart';

/// Bell action that displays an unread count badge when notifications are
/// pending. Exposes a semantic label that announces the unread count.
class AppBarNotificationButton extends StatelessWidget {
  const AppBarNotificationButton({
    super.key,
    required this.onPressed,
    this.count = 0,
  });

  final VoidCallback? onPressed;
  final int count;

  @override
  Widget build(BuildContext context) {
    final hasBadge = count > 0;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        AppBarActionButton(
          icon: Icons.notifications_none_rounded,
          tooltip: hasBadge ? 'Notifications, $count unread' : 'Notifications',
          onPressed: onPressed,
        ),
        if (hasBadge)
          Positioned(
            right: 8,
            top: 8,
            child: _Badge(count: count),
          ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final label = count > 99 ? '99+' : '$count';
    return Semantics(
      label: '$count unread',
      child: Container(
        constraints: const BoxConstraints(
          minWidth: AppBarSizes.notificationBadgeSize,
          minHeight: AppBarSizes.notificationBadgeSize,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: scheme.error,
          borderRadius: BorderRadius.circular(AppBarSizes.notificationBadgeSize),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: scheme.onError,
            fontSize: AppBarSizes.notificationBadgeText,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
