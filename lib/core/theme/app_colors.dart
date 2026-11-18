import 'package:flutter/material.dart';

/// Color tokens extracted directly from the approved Stitch project
/// (Neo-Print Curated design system & c5f4ae8c4c5043b2aa1fbb78e4105b85).
abstract final class AppColors {
  // Brand Palette
  static const Color purple = Color(0xFF6C3D75);
  static const Color purpleDark = Color(0xFF53265C);
  static const Color purpleLight = Color(0xFFFAF3F9);
  static const Color purpleFixed = Color(0xFFFDD6FF);

  static const Color brown = Color(0xFF795548);
  static const Color brownContainer = Color(0xFFFDCDBC);

  static const Color mint = Color(0xFF34D399);
  static const Color mintHover = Color(0xFF25B580);
  static const Color mintTint = Color(0x2634D399); // 15% opacity
  static const Color mintDeepText = Color(0xFF0F766E);
  static const Color filamentGlow = Color(0xFF02FFBB);

  static const Color charcoal = Color(0xFF2D292B);
  static const Color charcoalMuted = Color(0xFF645C60);
  static const Color onSurface = Color(0xFF1E1B1C);
  static const Color onSurfaceVariant = Color(0xFF4D444D);

  // Surfaces & Canvas
  static const Color background = Color(0xFFFAF7F9);
  static const Color canvasTint = Color(0xFFFAF8F9);
  static const Color surfaceBright = Color(0xFFFFF7F9);
  static const Color surfaceContainerLow = Color(0xFFFAF1F4);
  static const Color surfaceContainer = Color(0xFFF4ECEE);
  static const Color surfaceContainerHigh = Color(0xFFEFE6E8);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Borders & Glassmorphism
  static const Color border = Color(0xFFEFECEE);
  static const Color outlineVariant = Color(0xFFD0C2CE);
  static const Color surfaceGlass = Color(0xEBFFFFFF); // ~92% white
  static const Color surfaceBorderSubtle = Color(0x142D292B); // 8% charcoal

  // WhatsApp Dedicated Accents
  static const Color whatsappGreen = Color(0xFF25D366);
  static const Color whatsappDeep = Color(0xFF128C7E);

  // Semantic
  static const Color error = Color(0xFFBA1A1A);
  static const Color white = Color(0xFFFFFFFF);
}
