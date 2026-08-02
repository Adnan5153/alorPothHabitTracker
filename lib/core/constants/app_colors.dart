import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color sunStart = Color(0xFFFFC107);
  static const Color sunEnd = Color(0xFFFFD54F);
  static const Color sunCore = Color(0xFFFFF8E7);
  static const Color sunCoreShadow = Color(0xFFFFE7A8);

  static const Color pathStart = Color(0xFFF9C74F);
  static const Color pathEnd = Color(0xFFFFD166);

  static const List<Color> skyGradient = [
    Color(0xFFFFFFFF),
    Color(0xFFFAF9F6),
    Color(0xFFF8F9FA),
    Color(0xFFF2F2F7),
  ];

  static const List<Color> hillsPalette = [
    Color(0xFF5E8B3D),
    Color(0xFF3F7D58),
    Color(0xFF143A52),
    Color(0xFF204A60),
  ];

  static const Color plantGreen = Color(0xFF3F7D58);
  static const Color accent = Color(0xFFF59E0B);

  static const Color darkSlate900 = Color(0xFF0F172A);
  static const Color darkSlate800 = Color(0xFF1E293B);
  static const List<Color> darkGradient = [
    Color(0xFF020617),
    darkSlate900,
    darkSlate800,
  ];

  static const Color titleLight = Colors.white;
  static const Color taglineLight = Color(0xFFF5F5F5);

  static const Color titleDark = Colors.white;
  static const Color taglineDark = Color(0xFFCBD5E1);
}
