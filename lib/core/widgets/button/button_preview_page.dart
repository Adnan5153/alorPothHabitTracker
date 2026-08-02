import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import 'button_extensions.dart';
import 'primary_button.dart';

/// Catalog façade used by the Widget Builder to render every supported
/// button configuration.
class ButtonPreviewRegistrar {
  ButtonPreviewRegistrar._();

  static const Map<ButtonVariant, String> variantLabels = {
    ButtonVariant.primary: 'Primary',
    ButtonVariant.secondary: 'Secondary',
  };

  static List<ButtonVariant> get registeredVariants => ButtonVariant.values;

  static Widget build(
    ButtonVariant variant, {
    ButtonSize size = ButtonSize.medium,
    bool isLoading = false,
    bool isEnabled = true,
    bool withLeadingIcon = false,
    bool withTrailingIcon = false,
    String? labelOverride,
  }) {
    final label = labelOverride ?? variantLabels[variant]!;
    final handler = isEnabled ? () {} : null;
    final leadingIcon = withLeadingIcon ? Icons.arrow_forward_rounded : null;
    final trailingIcon = withTrailingIcon ? Icons.chevron_right_rounded : null;

    return switch (variant) {
      ButtonVariant.primary => PrimaryButton(
          label: label,
          onPressed: handler,
          size: size,
          isLoading: isLoading,
          leadingIcon: leadingIcon,
          trailingIcon: trailingIcon,
        ),
      ButtonVariant.secondary => SecondaryButton(
          label: label,
          onPressed: handler,
          size: size,
          isLoading: isLoading,
          icon: leadingIcon,
        ),
    };
  }

  static const List<ButtonWidgetSample> samples = <ButtonWidgetSample>[
    ButtonWidgetSample(
      key: 'button-primary',
      title: 'Primary',
      description: 'Filled Liquid Glass CTA with animated press feedback.',
      builder: _buildPrimarySamples,
    ),
    ButtonWidgetSample(
      key: 'button-secondary',
      title: 'Secondary',
      description: 'Tonal Liquid Glass action with a translucent glass body.',
      builder: _buildSecondarySamples,
    ),
    ButtonWidgetSample(
      key: 'button-responsive',
      title: 'Responsive sizing',
      description: 'Same button rendered across phone, tablet and desktop widths.',
      builder: _buildResponsiveSamples,
    ),
  ];

  static Widget _buildPrimarySamples(BuildContext context) => Column(
        children: [
          for (final size in ButtonSize.values)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.space12),
              child: build(
                ButtonVariant.primary,
                size: size,
                withLeadingIcon: true,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.space12),
            child: build(ButtonVariant.primary, isLoading: true),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.space12),
            child: build(
              ButtonVariant.primary,
              isEnabled: false,
              withLeadingIcon: true,
            ),
          ),
          build(
            ButtonVariant.primary,
            withLeadingIcon: true,
            withTrailingIcon: true,
          ),
        ],
      );

  static Widget _buildSecondarySamples(BuildContext context) => Column(
        children: [
          for (final size in ButtonSize.values)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.space12),
              child: build(
                ButtonVariant.secondary,
                size: size,
                withLeadingIcon: true,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.space12),
            child: build(ButtonVariant.secondary, isLoading: true),
          ),
          build(ButtonVariant.secondary, isEnabled: false),
        ],
      );

  static Widget _buildResponsiveSamples(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final previewWidth = maxWidth >= 1024
            ? 520.0
            : maxWidth >= 600
                ? 360.0
                : maxWidth;
        return Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: previewWidth,
            child: build(
              ButtonVariant.primary,
              withLeadingIcon: true,
              withTrailingIcon: true,
            ),
          ),
        );
      },
    );
  }
}

/// Catalog descriptor compatible with the Widget Builder convention.
class ButtonWidgetSample {
  const ButtonWidgetSample({
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

/// Visual preview for the Liquid Glass button family. Rendered as a
/// standalone route and surfaced through the Widget Builder catalog.
class ButtonPreviewPage extends StatelessWidget {
  const ButtonPreviewPage({super.key});

  static const String routeName = '/button-preview';

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(title: const Text('Button Preview')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSizes.space16),
        itemCount: ButtonPreviewRegistrar.samples.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSizes.space24),
        itemBuilder: (context, index) {
          final sample = ButtonPreviewRegistrar.samples[index];
          return _SampleTile(sample: sample);
        },
      ),
    );
  }
}

class _SampleTile extends StatelessWidget {
  const _SampleTile({required this.sample});

  final ButtonWidgetSample sample;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sample.title, style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSizes.space4),
        Text(
          sample.description,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSizes.space12),
        sample.builder(context),
      ],
    );
  }
}
