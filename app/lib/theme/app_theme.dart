import 'package:flutter/material.dart';

class AppColors {
  static const nearBlack = Color(0xFF333333);
  static const darkGreen = Color(0xFF0D572C);
  static const primaryGreen = Color(0xFF6B9E4D);
  static const lightGreen = Color(0xFFA0D468);
  static const pastelGreen = Color(0xFFD9EDC8);
  static const cream = Color(0xFFF8F5EB);
  static const surface = Color(0xFFFFFCF6);
  static const lightSurface = Color(0xFFF0F2EA);
  static const warmDark = Color(0xFF666666);
  static const gray = Color(0xFF8A8F91);
  static const mutedGray = Color(0xFF7E878A);
  static const positive = Color(0xFF197A34);
  static const danger = Color(0xFFFF6B6B);
  static const warning = Color(0xFFFFD700);
  static const wiseGreen = primaryGreen;
  static const lightMint = pastelGreen;
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
          fontSize: 54,
          fontWeight: FontWeight.w900,
          height: .92,
          color: AppColors.darkGreen,
        ),
        headlineMedium: TextStyle(
          fontFamilyFallback: _gameFontFallback,
          fontSize: 30,
          fontWeight: FontWeight.w900,
          height: 1.05,
          color: AppColors.nearBlack,
        ),
        titleLarge: TextStyle(
          fontFamilyFallback: _gameFontFallback,
          fontSize: 23,
          fontWeight: FontWeight.w900,
          height: 1.12,
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
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.42,
          color: AppColors.nearBlack,
        ),
        bodyMedium: TextStyle(
          fontFamilyFallback: _gameFontFallback,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.45,
          color: AppColors.warmDark,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
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
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontFamilyFallback: _gameFontFallback,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.nearBlack,
          side: const BorderSide(color: Color(0x1F0E0F0C)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD8E4D1), width: 1.4),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD8E4D1), width: 1.4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.primaryGreen,
            width: 1.6,
          ),
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
