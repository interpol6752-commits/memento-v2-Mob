import 'package:flutter/material.dart';

class AppTheme {
  static const Color bgDark = Color(0xFF0A0E0D);
  static const Color cardBg = Color(0xFF121A16);
  static const Color cardBorder = Color(0xFF1E2E25);
  static const Color neonGreen = Color(0xFF00FF66);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      primaryColor: neonGreen,
      colorScheme: const ColorScheme.dark(
        primary: neonGreen,
        surface: cardBg,
      ),
    );
  }
}
