class AppSizes {
  AppSizes._();

  // Spacing scale (4-pt grid).
  static const double space4 = 4;
  static const double space8 = 8;
  static const double space12 = 12;
  static const double space16 = 16;
  static const double space20 = 20;
  static const double space24 = 24;
  static const double space32 = 32;
  static const double space40 = 40;
  static const double space48 = 48;
  static const double space64 = 64;

  // Screen padding.
  static const double screenPaddingHorizontal = 24;
  static const double screenPaddingVertical = 32;

  // Splash layout flex weights (must sum to 100).
  static const int splashTopFlex = 15;
  static const int splashIllustrationFlex = 55;
  static const int splashBrandingFlex = 20;
  static const int splashBottomFlex = 10;

  // Splash visuals.
  static const double splashGlowBase = 200;
  static const double splashGlowGrow = 60;
  static const double splashScaleMin = 0.96;
  static const double splashScaleGain = 0.04;

  // Animation timing.
  static const Duration splashDuration = Duration(milliseconds: 3000);
  static const Duration splashExitDuration = Duration(milliseconds: 400);
  static const Duration loadingIndicatorPeriod = Duration(milliseconds: 1800);

  // Loading indicator dimensions.
  static const double loadingIndicatorWidth = 96;
  static const double loadingIndicatorHeight = 28;

  // Typography — font sizes.
  static const double fontSizeBody = 16;
  static const double fontSizeTitle = 36;
  static const double fontSizeOnboardingTitle = 32;

  // Typography — letter spacing.
  static const double letterSpacingTitle = 0.5;

  // Illustration painter (sun/path/hills normalized coordinates).
  static const double hillHorizonStart = 0.55;
  static const double hillHorizonEnd = 1.00;
  static const double hillMidStart = 0.70;
  static const double hillMidEnd = 1.00;
  static const double hillBackPeak = 0.75;
  static const double hillBackDip = 0.70;
  static const double hillBackEdge = 0.68;
  static const double hillBackShoulder1 = 0.62;
  static const double hillBackShoulder2 = 0.78;
  static const double hillMidPeak = 0.85;
  static const double hillMidDip = 0.82;
  static const double hillMidEdge = 0.84;
  static const double hillMidShoulder1 = 0.72;
  static const double hillMidShoulder2 = 0.90;

  // Sun and rays.
  static const double sunRadius = 0.085;
  static const double sunHaloRadiusMul = 3.2;
  static const double sunRayInnerMul = 1.25;
  static const double sunRayOuterMul = 1.9;
  static const int sunRayCount = 12;
  static const double sunStartY = 0.62;
  static const double sunEndY = 0.42;
  static const double sunCenterX = 0.55;

  // Golden path.
  static const double goldenPathStartX = 0.46;
  static const double goldenPathStartY = 0.92;
  static const double goldenPathEndX = 0.50;
  static const double goldenPathEndY = 0.66;
  static const double goldenPathCtrlX1 = 0.55;
  static const double goldenPathCtrlY1 = 0.78;
  static const double goldenPathCtrlX2 = 0.35;
  static const double goldenPathCtrlY2 = 0.70;
  static const double goldenPathStrokeWidth = 0.018;
  static const double goldenPathGlowRadiusMul = 0.022;
  static const double goldenPathCoreRadiusMul = 0.008;

  // Plant.
  static const double plantScaleMin = 0.95;
  static const double plantScaleGain = 0.05;
  static const double plantBaseX = 0.22;
  static const double plantBaseY = 0.78;
  static const double plantStemThickness = 3.5;
  static const double plantStemLength = 0.20;
  static const double plantCurve = 0.02;
  static const double plantTipY = 0.0;
  static const double plantMid1Y = 0.13;
  static const double plantMid2Y = 0.08;
  static const double plantMid3Y = 0.02;
  static const double plantMid1X = 0.02;
  static const double plantMid2X = 0.01;
  static const double plantRotLeft = 0.6;
  static const double plantRotRight = 0.5;
  static const double plantRotCenter = 0.0;
  static const double plantLeafLarge = 0.05;
  static const double plantLeafMedium = 0.045;
  static const double plantLeafSmall = 0.04;

  // Stars (dark mode).
  static const int starCount = 28;
  static const double starAreaTop = 0.45;
  static const double starRadiusMin = 0.4;
  static const double starRadiusRange = 1.4;

  // Cloud sizes.
  static const double cloudLarge = 36;
  static const double cloudMedium = 28;
  static const double cloudSmall = 22;
  static const double cloudEdgeFactor = 0.7;
  static const double cloudEdgeOffsetY = 0.15;
  static const double cloudMidOffsetY = 0.2;
  static const double cloudLeftX = 0.18;
  static const double cloudLeftY = 0.18;
  static const double cloudRightX = 0.78;
  static const double cloudRightY = 0.12;
  static const double cloudTopX = 0.55;
  static const double cloudTopY = 0.06;

  // Horizon glow.
  static const double horizonGlowY = -0.1;
  static const double horizonGlowRadius = 0.65;
  static const double horizonGlowAlphaDark = 0.18;
  static const double horizonGlowAlphaLight = 0.35;
  static const double horizonGlowHaloAlpha = 0.55;
}
