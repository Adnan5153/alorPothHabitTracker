import 'package:flutter/material.dart';

import 'app_bar_extensions.dart';
import 'custom_app_bar.dart';
import 'custom_sliver_app_bar.dart';

/// Visual preview for every supported AppBar variant. The screen is wired
/// into the Widget Builder catalog and is also exposed as a standalone
/// route for design review.
class AppBarPreviewPage extends StatelessWidget {
  const AppBarPreviewPage({super.key});

  static const String routeName = '/appbar-preview';

  @override
  Widget build(BuildContext context) {
    final entries = AppBarPreviewRegistrar.registeredVariants
        .map((variant) => _PreviewEntry(variant))
        .toList(growable: false);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: 'AppBar Preview',
            largeTitle: 'AppBar Preview',
            variant: AppBarVariant.largeTitle,
          ),
          SliverList.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) => _PreviewTile(entry: entries[index]),
          ),
        ],
      ),
    );
  }
}

class _PreviewEntry {
  const _PreviewEntry(this.variant);

  final AppBarVariant variant;

  String get label => AppBarPreviewRegistrar.variantLabels[variant] ?? '';
}

class _PreviewTile extends StatelessWidget {
  const _PreviewTile({required this.entry});

  final _PreviewEntry entry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          color: scheme.surfaceContainerHighest,
          child: Text(entry.label, style: Theme.of(context).textTheme.labelLarge),
        ),
        Container(
          color: scheme.surface,
          child: Column(
            children: [
              AppBarPreviewRegistrar.build(entry.variant),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Toolbar preview',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Catalog façade that registers every AppBar variant in the Widget
/// Builder and exposes factories for each preset.
class AppBarPreviewRegistrar {
  AppBarPreviewRegistrar._();

  static const Map<AppBarVariant, String> variantLabels = {
    AppBarVariant.defaultBar: 'Default',
    AppBarVariant.dashboard: 'Dashboard',
    AppBarVariant.profile: 'Profile',
    AppBarVariant.search: 'Search',
    AppBarVariant.transparent: 'Transparent',
    AppBarVariant.gradient: 'Gradient',
    AppBarVariant.largeTitle: 'Large Title',
    AppBarVariant.centered: 'Centered',
    AppBarVariant.minimal: 'Minimal',
    AppBarVariant.settings: 'Settings',
    AppBarVariant.details: 'Details',
    AppBarVariant.ai: 'AI Screen',
    AppBarVariant.statistics: 'Statistics',
    AppBarVariant.calendar: 'Calendar',
    AppBarVariant.leaderboard: 'Leaderboard',
  };

  static List<AppBarVariant> get registeredVariants => AppBarVariant.values;

  static CustomAppBar build(AppBarVariant variant) {
    return CustomAppBar(
      title: variantLabels[variant] ?? 'Untitled',
      subtitle: 'Subtitle text',
      variant: variant,
      notificationCount: variant.showNotification ? 3 : 0,
      showTheme: variant.showTheme,
      themeMode: ThemeMode.system,
      onThemeChanged: (_) {},
    );
  }
}
