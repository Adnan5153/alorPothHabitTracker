import 'package:flutter/material.dart';

import 'app_bar_constants.dart';
import 'app_bar_extensions.dart';

/// Standard compact title used inside a fixed toolbar row.
class AppBarTitle extends StatelessWidget {
  const AppBarTitle(
    this.text, {
    super.key,
    this.style,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });

  final String text;
  final TextStyle? style;
  final int maxLines;
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    final fontSize = context.isCompact
        ? AppBarSizes.compactTitleFontSize
        : AppBarSizes.compactTitleFontSize + 2;
    final resolved = style ??
        AppBarColors.titleTextStyle(context).copyWith(
          color: AppBarColors.foreground(context),
          fontSize: fontSize,
        );
    return Semantics(
      header: true,
      child: Text(
        text,
        maxLines: maxLines,
        overflow: overflow,
        style: resolved,
      ),
    );
  }
}

/// Secondary caption rendered beneath an [AppBarTitle].
class AppBarSubtitle extends StatelessWidget {
  const AppBarSubtitle(
    this.text, {
    super.key,
    this.style,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });

  final String text;
  final TextStyle? style;
  final int maxLines;
  final TextOverflow overflow;

  @override
  Widget build(BuildContext context) {
    final base = AppBarColors.titleTextStyle(context).copyWith(
      color: AppBarColors.muted(context),
      fontSize: 12,
      fontWeight: FontWeight.w400,
    );
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      style: style ?? base,
    );
  }
}

/// Large collapsing title used inside SliverAppBar flexible space.
class AppBarLargeTitle extends StatelessWidget {
  const AppBarLargeTitle(
    this.text, {
    super.key,
    this.style,
    this.maxLines = 2,
  });

  final String text;
  final TextStyle? style;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final resolved = style ??
        AppBarColors.titleTextStyle(context).copyWith(
          color: AppBarColors.foreground(context),
          fontSize: AppBarSizes.largeTitleFontSize,
          fontWeight: FontWeight.w700,
        );
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: resolved,
    );
  }
}