import 'package:flutter/material.dart';

import '../../../extensions/build_context_extensions.dart';
import '../../appbar/app_bar_extensions.dart';
import '../../appbar/custom_app_bar.dart';
import '../liquid_background/liquid_background.dart';
import '../liquid_background/liquid_background_constants.dart';
import '../liquid_body/liquid_body.dart';
import '../liquid_overlay/liquid_loading.dart';
import '../liquid_overlay/liquid_overlay.dart';
import '../liquid_scaffold_extensions/liquid_scaffold_context_extensions.dart';
import '../liquid_scaffold_theme/liquid_scaffold_theme.dart';
import '../liquid_scaffold_theme/liquid_scaffold_theme_data.dart';
import 'liquid_scaffold_constants.dart';

/// Global screen surface for the Alor Poth design system. Wraps a
/// Material [Scaffold] (preserving SnackBars / dialogs / focus traversal)
/// then layers (back to front):
///
///  - background slot (`LiquidBackground`)
///  - body slot (`LiquidBody`)
///  - optional overlay slot (`LiquidOverlay`)
///  - optional loading chrome (`LiquidLoading`)
///
/// If `appBar` is null and `title` is provided, a default
/// `CustomAppBar` is built automatically. If `errorState` or `emptyState`
/// is non-null they take precedence over `body`.
class LiquidScaffold extends StatelessWidget {
  const LiquidScaffold({
    super.key,
    this.title,
    this.subtitle,
    this.appBar,
    this.body,
    this.errorState,
    this.emptyState,
    this.background,
    this.backgroundGradient,
    this.backgroundImage,
    this.backgroundImageFit = LiquidScaffoldDefaults.defaultBackgroundImageFit,
    this.backgroundBlur = false,
    this.ambient = LiquidScaffoldDefaults.defaultAmbient,
    this.overlay,
    this.loading = LiquidScaffoldDefaults.defaultLoading,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.persistentFooterButtons,
    this.drawer,
    this.endDrawer,
    this.scrollable = LiquidScaffoldDefaults.defaultScrollable,
    this.padding,
    this.responsivePadding = LiquidScaffoldDefaults.defaultResponsivePadding,
    this.safeTop = LiquidScaffoldDefaults.defaultSafeTop,
    this.safeBottom = LiquidScaffoldDefaults.defaultSafeBottom,
    this.safeLeft = LiquidScaffoldDefaults.defaultSafeLeft,
    this.safeRight = LiquidScaffoldDefaults.defaultSafeRight,
    this.entranceAnimation = LiquidScaffoldDefaults.defaultEntranceAnimation,
    this.primary = LiquidScaffoldDefaults.defaultPrimary,
    this.extendBody = LiquidScaffoldDefaults.defaultExtendBody,
    this.extendBodyBehindAppBar =
        LiquidScaffoldDefaults.defaultExtendBodyBehindAppBar,
    this.resizeToAvoidBottomInset,
  });

  final String? title;
  final String? subtitle;
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? errorState;
  final Widget? emptyState;

  // Background slot.
  final Widget? background;
  final Gradient? backgroundGradient;
  final ImageProvider? backgroundImage;
  final BoxFit backgroundImageFit;
  final bool backgroundBlur;
  final AmbientBackgroundStyle ambient;

  // Overlay + loading.
  final Widget? overlay;
  final bool loading;

  // Material Scaffold passthroughs.
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final List<Widget>? persistentFooterButtons;
  final Widget? drawer;
  final Widget? endDrawer;

  // Body composition.
  final bool scrollable;
  final EdgeInsets? padding;
  final bool responsivePadding;
  final bool safeTop;
  final bool safeBottom;
  final bool safeLeft;
  final bool safeRight;
  final bool entranceAnimation;
  final bool primary;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final bool? resizeToAvoidBottomInset;

  PreferredSizeWidget? _resolveAppBar() {
    if (appBar != null) return appBar;
    if (title != null) {
      return CustomAppBar(
        title: title!,
        subtitle: subtitle,
        variant: AppBarVariant.defaultBar,
      );
    }
    return null;
  }

  Widget _resolveBody() {
    if (errorState != null) return errorState!;
    if (emptyState != null) return emptyState!;
    return body ?? const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldThemeData = context.hasLiquidScaffoldTheme
        ? null
        : (context.isDark
            ? LiquidScaffoldThemeData.dark
            : LiquidScaffoldThemeData.light);

    final content = Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: LiquidBackground(
            background: background,
            gradient: backgroundGradient,
            image: backgroundImage,
            imageFit: backgroundImageFit,
            blurImage: backgroundBlur,
            ambient: ambient,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: _resolveAppBar(),
          body: LiquidBody(
            padding: padding,
            responsivePadding: responsivePadding,
            scrollable: scrollable,
            entranceAnimation: entranceAnimation,
            safeTop: safeTop,
            safeBottom: safeBottom,
            safeLeft: safeLeft,
            safeRight: safeRight,
            child: _resolveBody(),
          ),
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          bottomNavigationBar: bottomNavigationBar,
          bottomSheet: bottomSheet,
          persistentFooterButtons: persistentFooterButtons,
          drawer: drawer,
          endDrawer: endDrawer,
          primary: primary,
          extendBody: extendBody,
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        ),
        if (overlay != null) LiquidOverlay(child: overlay!),
        if (loading) const LiquidLoading(),
      ],
    );

    if (scaffoldThemeData == null) return content;
    return LiquidScaffoldTheme(data: scaffoldThemeData, child: content);
  }
}