import 'package:flutter/material.dart';

class AppColors {
  static const nearBlack = Color(0xFF0E0F0C);
  static const darkGreen = Color(0xFF163300);
  static const wiseGreen = Color(0xFF9FE870);
  static const lightMint = Color(0xFFE2F6D5);
  static const surface = Color(0xFFF7F8F3);
  static const lightSurface = Color(0xFFE8EBE6);
  static const warmDark = Color(0xFF454745);
  static const gray = Color(0xFF868685);
  static const positive = Color(0xFF054D28);
  static const danger = Color(0xFFD03238);
  static const warning = Color(0xFFFFD11A);
}

class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.wiseGreen,
      brightness: Brightness.light,
      primary: AppColors.wiseGreen,
      onPrimary: AppColors.darkGreen,
      surface: AppColors.surface,
      onSurface: AppColors.nearBlack,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surface,
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 54,
          fontWeight: FontWeight.w900,
          height: .88,
          color: AppColors.nearBlack,
        ),
        headlineMedium: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w900,
          height: .9,
          color: AppColors.nearBlack,
        ),
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.nearBlack,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.nearBlack,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.35,
          color: AppColors.nearBlack,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.4,
          color: AppColors.warmDark,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.nearBlack,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: AppColors.nearBlack,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.wiseGreen,
          foregroundColor: AppColors.darkGreen,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.nearBlack,
          side: const BorderSide(color: Color(0x1F0E0F0C)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0x1F0E0F0C)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0x1F0E0F0C)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.nearBlack, width: 1.2),
        ),
      ),
    );
  }
}

String formatKrw(num value) {
  final sign = value < 0 ? '-' : '';
  final digits = value.abs().round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final fromEnd = digits.length - i;
    buffer.write(digits[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '$sign$buffer원';
}

String formatPoint(num value) {
  final digits = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final fromEnd = digits.length - i;
    buffer.write(digits[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '${buffer}P';
}
