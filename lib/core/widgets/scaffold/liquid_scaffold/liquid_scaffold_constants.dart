import 'package:flutter/material.dart';

import '../liquid_background/liquid_background_constants.dart';

abstract final class LiquidScaffoldDefaults {
  static const bool defaultLoading = false;
  static const bool defaultScrollable = false;
  static const bool defaultResponsivePadding = false;
  static const bool defaultEntranceAnimation = false;
  static const bool defaultSafeTop = true;
  static const bool defaultSafeBottom = true;
  static const bool defaultSafeLeft = true;
  static const bool defaultSafeRight = true;
  static const bool defaultPrimary = true;
  static const bool defaultExtendBody = false;
  static const bool defaultExtendBodyBehindAppBar = false;
  static const BoxFit defaultBackgroundImageFit = BoxFit.cover;
  static const AmbientBackgroundStyle defaultAmbient = AmbientBackgroundStyle();
}
