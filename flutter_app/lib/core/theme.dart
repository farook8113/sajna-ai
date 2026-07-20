import 'package:flutter/material.dart';

class SajnaTheme {
  static const Color primaryRed = Color(0xFFD20A11);
  static const Color primaryContainerDark = Color(0xFF410006);
  static const Color onPrimaryContainerDark = Color(0xFFFFDAD9);
  
  static const Color bgDark = Color(0xFF121214);
  static const Color surfaceDark = Color(0xFF1C1C1E);
  static const Color surfaceDarkVar = Color(0xFF252528);
  static const Color borderDark = Color(0xFF323235);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryRed,
        brightness: Brightness.dark,
        primary: primaryRed,
        onPrimary: Colors.white,
        background: bgDark,
        surface: surfaceDark,
        surfaceVariant: surfaceDarkVar,
        outline: borderDark,
      ),
      scaffoldBackgroundColor: bgDark,
      cardTheme: CardTheme(
        color: surfaceDark,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderDark, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceDark,
        elevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceDark,
        indicatorColor: primaryRed.withOpacity(0.15),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryRed,
        brightness: Brightness.light,
        primary: primaryRed,
        onPrimary: Colors.white,
        background: const Color(0xFFF4F5F7),
        surface: Colors.white,
        surfaceVariant: const Color(0xFFF0F0F3),
        outline: const Color(0xFFE0E2E7),
      ),
      scaffoldBackgroundColor: const Color(0xFFF4F5F7),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE0E2E7), width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: primaryRed.withOpacity(0.1),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
}
