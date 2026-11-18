import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_tokens.dart';
import 'app_typography.dart';

/// Centralized ThemeData adhering to Stitch Neo-Print Curated.
/// Material 3 is used only where it does not conflict with the approved design.
abstract final class AppTheme {
  static ThemeData build({required bool isArabic}) {
    final textTheme = AppTypography.buildTextTheme(isArabic: isArabic);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.purple,
        onPrimary: AppColors.white,
        primaryContainer: AppColors.purpleLight,
        onPrimaryContainer: AppColors.purpleDark,
        secondary: AppColors.brown,
        onSecondary: AppColors.white,
        secondaryContainer: AppColors.brownContainer,
        onSecondaryContainer: AppColors.brown,
        tertiary: AppColors.mint,
        onTertiary: AppColors.white,
        surface: AppColors.cardBackground,
        onSurface: AppColors.charcoal,
        onSurfaceVariant: AppColors.charcoalMuted,
        outline: AppColors.border,
        outlineVariant: AppColors.outlineVariant,
        error: AppColors.error,
        onError: AppColors.white,
      ),
      textTheme: textTheme,
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusCard),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTokens.spaceMd,
          vertical: AppTokens.spaceSm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusPill),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusPill),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusPill),
          borderSide: const BorderSide(color: AppColors.purple, width: 1.5),
        ),
      ),
    );
  }
}
