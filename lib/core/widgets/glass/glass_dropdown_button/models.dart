import 'package:flutter/material.dart';

import '../glass_container/constants.dart';
import 'constants.dart';

/// Generic drop-down item contract. Exposes the stable [value] used for
/// selection / equality plus a label, optional subtitle, leading, trailing.
@immutable
class GlassDropdownItem<T> {
  const GlassDropdownItem({
    required this.value,
    required this.label,
    this.subtitle,
    this.leading,
    this.trailing,
  });

  final T value;
  final String label;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is GlassDropdownItem<T> && other.value == value);

  @override
  int get hashCode => Object.hash(value, label);
}

/// Compile-time view-model for [GlassDropdownButton] resolved from
/// [GlassSize]. Keeps the body compact.
@immutable
class GlassDropdownButtonMetrics {
  const GlassDropdownButtonMetrics({
    required this.verticalPadding,
    required this.leadingIconSize,
  });

  factory GlassDropdownButtonMetrics.of(GlassSize size) {
    return switch (size) {
      GlassSize.small => const GlassDropdownButtonMetrics(
          verticalPadding: GlassDropdownButtonConstants.padVSmall,
          leadingIconSize: GlassDropdownButtonConstants.leadingIconSmall,
        ),
      GlassSize.medium => const GlassDropdownButtonMetrics(
          verticalPadding: GlassDropdownButtonConstants.padVMedium,
          leadingIconSize: GlassDropdownButtonConstants.leadingIconMedium,
        ),
      GlassSize.large => const GlassDropdownButtonMetrics(
          verticalPadding: GlassDropdownButtonConstants.padVLarge,
          leadingIconSize: GlassDropdownButtonConstants.leadingIconLarge,
        ),
    };
  }

  final double verticalPadding;
  final double leadingIconSize;
}

/// Validation / runtime state surfaced by the trigger.
enum GlassDropdownState { idle, error, loading, disabled }
