import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF715363);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryFixed = Color(0xFFFFD8EB);
  static const Color primaryFixedDim = Color(0xFFE2BCCF);
  static const Color onPrimaryFixed = Color(0xFF2B1422);
  static const Color onPrimaryFixedVariant = Color(0xFF5A3F4E);

  static const Color secondary = Color(0xFF5E5B76);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryFixed = Color(0xFFE3DFFF);
  static const Color secondaryFixedDim = Color(0xFFC7C3E2);
  static const Color onSecondaryFixed = Color(0xFF1A1930);
  static const Color onSecondaryFixedVariant = Color(0xFF46445D);

  static const Color surface = Color(0xFFF9F9F9);
  static const Color surfaceBright = Color(0xFFF9F9F9);
  static const Color surfaceContainerLow = Color(0xFFF3F3F4);
  static const Color surfaceContainer = Color(0xFFEEEEEE);
  static const Color surfaceContainerHigh = Color(0xFFE8E8E8);
  static const Color surfaceContainerHighest = Color(0xFFE2E2E2);
  
  static const Color onSurface = Color(0xFF1A1C1C);
  static const Color onSurfaceVariant = Color(0xFF4E4448);
  static const Color outline = Color(0xFF7F7479);
  static const Color outlineVariant = Color(0xFFD1C3C8);
  
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFE3DFFF);
  static const Color onSecondaryContainer = Color(0xFF64617C);
  static const Color error = Color(0xFFBA1A1A);

  static const Color tertiary = Color(0xFF5C5C5C);
  static const Color primaryContainer = Color(0xFFFFD8EB);
  static const Color onTertiaryFixedVariant = Color(0xFF474747);

  static const Color background = Color(0xFFF9F9F9);
  static const Color onBackground = Color(0xFF1A1C1C);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        surface: surface,
        onSurface: onSurface,
        outline: outline,
        outlineVariant: outlineVariant,
      ),
      scaffoldBackgroundColor: background,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.notoSerif(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02 * 40, // -0.02em
          color: onSurface,
          height: 1.2,
        ),
        headlineMedium: GoogleFonts.notoSerif(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: onSurface,
          height: 1.3,
        ),
        titleSmall: GoogleFonts.manrope(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: onSurface,
          height: 1.4,
        ),
        bodyMedium: GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: onSurface,
          height: 1.6,
        ),
        labelSmall: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1 * 12, // 0.1em
          color: onSurface,
          height: 1.0,
        ),
      ),
    );
  }
}
