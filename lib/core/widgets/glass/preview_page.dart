import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../extensions/build_context_extensions.dart';
import 'glass_card/exports.dart';
import 'glass_container/exports.dart';
import 'glass_dropdown_button/exports.dart';
import 'glass_dropdown_container/exports.dart';
import 'glass_primary_button/exports.dart';
import 'glass_summary_card/exports.dart';

/// Widget-Builder façade that exposes sample configurations of every
/// glass widget. The catalog is grouped by surface, each entry showing
/// a representative configuration across [GlassSize] tiers and key
/// states so designers can compare them in-place.
class GlassPreviewRegistrar {
  GlassPreviewRegistrar._();

  static final List<GlassWidgetSample> samples = <GlassWidgetSample>[
    GlassWidgetSample(
      key: 'glass-container',
      title: 'GlassContainer',
      description: 'Foundation surface with blur, gradient, tint and border.',
      builder: (context) => const _ContainerSampleBuilder(),
    ),
    GlassWidgetSample(
      key: 'glass-card',
      title: 'GlassCard',
      description: 'Title / subtitle / leading / trailing / body / footer slots.',
      builder: (context) => const _CardSampleBuilder(),
    ),
    GlassWidgetSample(
      key: 'glass-summary-card',
      title: 'GlassSummaryCard',
      description: 'Animated number, label, icon, progress, status, trend, chart.',
      builder: (context) => const _SummaryCardSampleBuilder(),
    ),
    GlassWidgetSample(
      key: 'glass-primary-button',
      title: 'GlassPrimaryButton',
      description: 'Filled glass CTA with loading, icon, gradient and ripple.',
      builder: (context) => const _PrimaryButtonSampleBuilder(),
    ),
    GlassWidgetSample(
      key: 'glass-dropdown-container',
      title: 'GlassDropdownContainer',
      description: 'Reusable blur popup surface used by every dropdown.',
      builder: (context) => const _DropdownContainerSampleBuilder(),
    ),
    GlassWidgetSample(
      key: 'glass-dropdown-button',
      title: 'GlassDropdownButton',
      description: 'Searchable selector with hint, validation, error and loading states.',
      builder: (context) => const _DropdownButtonSampleBuilder(),
    ),
  ];
}

/// Public descriptor for a single entry in the Widget Builder catalog.
class GlassWidgetSample {
  const GlassWidgetSample({
    required this.key,
    required this.title,
    required this.description,
    required this.builder,
  });

  final String key;
  final String title;
  final String description;
  final WidgetBuilder builder;
}

/// Visual preview for every glass widget. Wired into the Widget Builder
/// catalog and exposed as a standalone route for design review.
class GlassPreviewPage extends StatelessWidget {
  const GlassPreviewPage({super.key});

  static const String routeName = '/glass-preview';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Glass UI Preview')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.space16),
        itemCount: GlassPreviewRegistrar.samples.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSizes.space24),
        itemBuilder: (context, index) {
          final sample = GlassPreviewRegistrar.samples[index];
          return _SampleTile(sample: sample);
        },
      ),
    );
  }
}

class _SampleTile extends StatelessWidget {
  const _SampleTile({required this.sample});

  final GlassWidgetSample sample;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sample.title, style: context.textStyles.titleMedium),
        const SizedBox(height: 4),
        Text(
          sample.description,
          style: context.textStyles.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSizes.space12),
        sample.builder(context),
      ],
    );
  }
}

class _ContainerSampleBuilder extends StatelessWidget {
  const _ContainerSampleBuilder();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.space12,
      runSpacing: AppSizes.space12,
      children: [
        for (final tier in GlassTier.values)
          SizedBox(
            width: 180,
            child: GlassContainer(
              tier: tier,
              size: GlassSize.medium,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  tier.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CardSampleBuilder extends StatelessWidget {
  const _CardSampleBuilder();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GlassCard(
          size: GlassSize.medium,
          title: 'Active streak',
          subtitle: 'আপনার সাম্প্রতিক ধারাবাহিকতা',
          leading: const Icon(Icons.local_fire_department_rounded, color: Colors.orange),
          trailing: const Icon(Icons.chevron_right_rounded),
          body: const Text('৭ দিন ধরে আপনি প্রতিদিনের কাজ সম্পন্ন করছেন।'),
          onTap: () {},
        ),
        const SizedBox(height: AppSizes.space12),
        GlassCard(
          size: GlassSize.medium,
          title: 'Selected state',
          subtitle: 'এই কার্ডটি নির্বাচিত',
          leading: const Icon(Icons.bolt_rounded, color: Colors.amber),
          selected: true,
          onTap: () {},
        ),
        const SizedBox(height: AppSizes.space12),
        GlassCard(
          size: GlassSize.medium,
          title: 'Disabled state',
          subtitle: 'এই কার্ডটি নিষ্ক্রিয়',
          leading: const Icon(Icons.lock_outline_rounded),
          enabled: false,
          onTap: () {},
        ),
      ],
    );
  }
}

class _SummaryCardSampleBuilder extends StatelessWidget {
  const _SummaryCardSampleBuilder();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.space12,
      runSpacing: AppSizes.space12,
      children: [
        SizedBox(
          width: 220,
          child: GlassSummaryCard(
            label: 'আজকের অভ্যাস',
            value: 4,
            subtitle: 'গতকালের চেয়ে +1',
            icon: Icons.check_circle_rounded,
            progress: 0.4,
            statusLabel: 'Active',
            statusTone: GlassStatusTone.positive,
            trend: GlassTrend.up,
            trendValue: '+12%',
            size: GlassSize.medium,
          ),
        ),
        SizedBox(
          width: 220,
          child: GlassSummaryCard(
            label: 'ব্যর্থতার হার',
            value: 3,
            subtitle: 'গতকালের চেয়ে -1',
            icon: Icons.error_rounded,
            progress: 0.3,
            statusLabel: 'Warning',
            statusTone: GlassStatusTone.warning,
            trend: GlassTrend.down,
            trendValue: '-8%',
            size: GlassSize.medium,
          ),
        ),
        SizedBox(
          width: 220,
          child: GlassSummaryCard(
            label: 'সামগ্রিক স্কোর',
            value: 87,
            subtitle: 'এই সপ্তাহে',
            icon: Icons.star_rounded,
            progress: 0.87,
            statusLabel: 'Excellent',
            statusTone: GlassStatusTone.positive,
            trend: GlassTrend.up,
            trendValue: '+4',
            size: GlassSize.medium,
          ),
        ),
      ],
    );
  }
}

class _PrimaryButtonSampleBuilder extends StatelessWidget {
  const _PrimaryButtonSampleBuilder();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final size in GlassSize.values)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.space12),
            child: GlassPrimaryButton(
              label: 'Continue',
              size: size,
              leadingIcon: Icons.arrow_forward_rounded,
              onPressed: () {},
            ),
          ),
        GlassPrimaryButton(
          label: 'Loading',
          isLoading: true,
          onPressed: () {},
        ),
        const SizedBox(height: AppSizes.space12),
        GlassPrimaryButton(
          label: 'Disabled',
          onPressed: null,
        ),
      ],
    );
  }
}

class _DropdownContainerSampleBuilder extends StatelessWidget {
  const _DropdownContainerSampleBuilder();

  @override
  Widget build(BuildContext context) {
    const items = ['প্রতিদিন', 'সাপ্তাহিক', 'মাসিক', 'কাস্টম'];
    return GlassDropdownContainer(
      itemCount: items.length,
      itemBuilder: (context, index) => Text(items[index]),
      selectedIndex: 0,
      onItemSelected: (_) {},
    );
  }
}

class _DropdownButtonSampleBuilder extends StatefulWidget {
  const _DropdownButtonSampleBuilder();

  @override
  State<_DropdownButtonSampleBuilder> createState() =>
      _DropdownButtonSampleBuilderState();
}

class _DropdownButtonSampleBuilderState
    extends State<_DropdownButtonSampleBuilder> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    const items = <GlassDropdownItem<String>>[
      GlassDropdownItem(value: 'daily', label: 'প্রতিদিন'),
      GlassDropdownItem(value: 'weekly', label: 'সাপ্তাহিক'),
      GlassDropdownItem(value: 'monthly', label: 'মাসিক'),
      GlassDropdownItem(
        value: 'custom',
        label: 'কাস্টম',
        subtitle: 'নিজের সময়সূচি নির্বাচন করুন',
      ),
    ];

    return Column(
      children: [
        GlassDropdownButton<String>(
          items: items,
          value: _selected,
          hint: 'ফ্রিকোয়েন্সি নির্বাচন করুন',
          leadingIcon: Icons.event_rounded,
          searchable: true,
          onChanged: (value) => setState(() => _selected = value),
        ),
        const SizedBox(height: AppSizes.space12),
        GlassDropdownButton<String>(
          items: const [GlassDropdownItem(value: 'a', label: 'Loading state')],
          value: null,
          hint: 'লোড হচ্ছে',
          isLoading: true,
          onChanged: (_) {},
        ),
        const SizedBox(height: AppSizes.space12),
        GlassDropdownButton<String>(
          items: items,
          value: null,
          hint: 'ত্রুটি',
          error: 'একটি বিকল্প নির্বাচন করুন',
          onChanged: (_) {},
        ),
      ],
    );
  }
}