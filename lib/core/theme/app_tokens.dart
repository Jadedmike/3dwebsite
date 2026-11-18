import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Spacing, radii, elevation, and layout tokens matching Stitch Neo-Print Curated.
abstract final class AppTokens {
  // Spacing Scale
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 40.0;
  static const double space2Xl = 48.0;

  // Grid & Container Widths
  static const double maxContentWidth = 1280.0; // max-w-7xl
  static const double headerHeight = 80.0; // h-20
  static const double gutterDesktop = 24.0; // 1.5rem
  static const double gutterMobile = 16.0; // 1rem

  // Border Radii
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusCard = 16.0; // 1rem
  static const double radiusXl = 24.0;
  static const double radiusPill = 9999.0;

  // Shadows
  static const List<BoxShadow> shadowHeader = [
    BoxShadow(
      color: Color(0x05000000),
      blurRadius: 12,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> shadowCard = [
    BoxShadow(
      color: Color(0x0A2D292B),
      blurRadius: 24,
      spreadRadius: -4,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> shadowFloating = [
    BoxShadow(
      color: Color(0x1F2D292B),
      blurRadius: 40,
      spreadRadius: -8,
      offset: Offset(0, 20),
    ),
  ];

  static const List<BoxShadow> shadowPurpleGlow = [
    BoxShadow(
      color: Color(0x596C3D75),
      blurRadius: 20,
      spreadRadius: -2,
      offset: Offset(0, 8),
    ),
  ];

  // Glassmorphism helper decoration
  static BoxDecoration glassBox({double radius = radiusCard}) {
    return BoxDecoration(
      color: AppColors.surfaceGlass,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.border, width: 1),
      boxShadow: shadowCard,
    );
  }
}
