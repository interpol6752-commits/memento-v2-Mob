import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF090E0B);
  static const Color sidebarBg = Color(0xFF060A08);
  static const Color cardBg = Color(0xFF0E1712);
  static const Color cardBorder = Color(0xFF1B2E22);
  static const Color neonGreen = Color(0xFF00FF66);
  static const Color textMuted = Color(0xFF7A8B81);
  static const Color textLight = Color(0xFFE2E8F0);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: neonGreen,
      colorScheme: const ColorScheme.dark(
        surface: cardBg,
        primary: neonGreen,
        secondary: neonGreen,
      ),
      fontFamily: 'monospace',
    );
  }
}
