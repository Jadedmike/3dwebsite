import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography scale matching Stitch Neo-Print Curated using locally bundled
/// fonts in assets/fonts/:
/// - Headlines & Labels: Space Grotesk (with Noto Kufi Arabic for AR)
/// - Body: Plus Jakarta Sans (with Noto Kufi Arabic for AR)
abstract final class AppTypography {
  static const String spaceGrotesk = 'Space Grotesk';
  static const String plusJakartaSans = 'Plus Jakarta Sans';
  static const String notoKufiArabic = 'Noto Kufi Arabic';

  static TextStyle headlineStyle({
    required bool isArabic,
    required double fontSize,
    FontWeight fontWeight = FontWeight.w600,
    double? height,
    double? letterSpacing,
    Color color = AppColors.charcoal,
  }) {
    return TextStyle(
      fontFamily: isArabic ? notoKufiArabic : spaceGrotesk,
      fontFamilyFallback: isArabic
          ? const [notoKufiArabic, spaceGrotesk]
          : const [spaceGrotesk, notoKufiArabic],
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: isArabic ? 0 : letterSpacing,
      color: color,
    );
  }

  static TextStyle bodyStyle({
    required bool isArabic,
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    double? height,
    double? letterSpacing,
    Color color = AppColors.charcoal,
  }) {
    return TextStyle(
      fontFamily: isArabic ? notoKufiArabic : plusJakartaSans,
      fontFamilyFallback: isArabic
          ? const [notoKufiArabic, plusJakartaSans]
          : const [plusJakartaSans, notoKufiArabic],
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: isArabic ? 0 : letterSpacing,
      color: color,
    );
  }

  static TextTheme buildTextTheme({required bool isArabic}) {
    return TextTheme(
      displayLarge: headlineStyle(
        isArabic: isArabic,
        fontSize: 56,
        fontWeight: FontWeight.w700,
        height: 64 / 56,
        letterSpacing: -0.03 * 56,
      ),
      displayMedium: headlineStyle(
        isArabic: isArabic,
        fontSize: 38,
        fontWeight: FontWeight.w700,
        height: 44 / 38,
        letterSpacing: -0.02 * 38,
      ),
      headlineLarge: headlineStyle(
        isArabic: isArabic,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 40 / 32,
        letterSpacing: -0.02 * 32,
      ),
      headlineMedium: headlineStyle(
        isArabic: isArabic,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 32 / 24,
        letterSpacing: -0.01 * 24,
      ),
      headlineSmall: headlineStyle(
        isArabic: isArabic,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
      ),
      bodyLarge: bodyStyle(
        isArabic: isArabic,
        fontSize: 18,
        height: 28 / 18,
      ),
      bodyMedium: bodyStyle(
        isArabic: isArabic,
        fontSize: 15,
        height: 24 / 15,
      ),
      bodySmall: bodyStyle(
        isArabic: isArabic,
        fontSize: 13,
        height: 20 / 13,
        color: AppColors.charcoalMuted,
      ),
      labelLarge: headlineStyle(
        isArabic: isArabic,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        letterSpacing: 0.04 * 14,
      ),
      labelMedium: headlineStyle(
        isArabic: isArabic,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        letterSpacing: 0.06 * 12,
      ),
      labelSmall: headlineStyle(
        isArabic: isArabic,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        height: 14 / 10,
        letterSpacing: 0.08 * 10,
      ),
    );
  }
}
