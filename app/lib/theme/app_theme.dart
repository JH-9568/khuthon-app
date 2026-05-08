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
  static const _gameFontFallback = <String>[
    'Arial Rounded MT Bold',
    'Apple SD Gothic Neo',
    'Noto Sans CJK KR',
    'Roboto',
    'sans-serif',
  ];

  static const _logoShadow = <Shadow>[
    Shadow(color: Color(0x220E0F0C), blurRadius: 0, offset: Offset(0, 2)),
  ];

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
      fontFamily: 'Arial Rounded MT Bold',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamilyFallback: _gameFontFallback,
          fontSize: 48,
          fontWeight: FontWeight.w900,
          height: .9,
          color: AppColors.nearBlack,
        ),
        headlineMedium: TextStyle(
          fontFamilyFallback: _gameFontFallback,
          fontSize: 29,
          fontWeight: FontWeight.w900,
          height: .96,
          color: AppColors.nearBlack,
        ),
        titleLarge: TextStyle(
          fontFamilyFallback: _gameFontFallback,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          height: 1.1,
          color: AppColors.nearBlack,
        ),
        titleMedium: TextStyle(
          fontFamilyFallback: _gameFontFallback,
          fontSize: 17,
          fontWeight: FontWeight.w900,
          height: 1.15,
          color: AppColors.nearBlack,
        ),
        bodyLarge: TextStyle(
          fontFamilyFallback: _gameFontFallback,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          height: 1.42,
          color: AppColors.nearBlack,
        ),
        bodyMedium: TextStyle(
          fontFamilyFallback: _gameFontFallback,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          height: 1.45,
          color: AppColors.warmDark,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.nearBlack,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamilyFallback: _gameFontFallback,
          fontSize: 25,
          fontWeight: FontWeight.w900,
          color: AppColors.nearBlack,
          shadows: _logoShadow,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.wiseGreen,
          foregroundColor: AppColors.darkGreen,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontFamilyFallback: _gameFontFallback,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.nearBlack,
          side: const BorderSide(color: Color(0x1F0E0F0C)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(
            fontFamilyFallback: _gameFontFallback,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
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
  final sign = value < 0 ? '-' : '';
  final digits = value.abs().round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final fromEnd = digits.length - i;
    buffer.write(digits[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '$sign${buffer}P';
}
