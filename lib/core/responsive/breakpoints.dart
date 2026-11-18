import 'package:flutter/widgets.dart';
import '../theme/app_tokens.dart';

enum ScreenSizeClass { mobile, tablet, desktop }

/// Responsive breakpoints matching Stitch Neo-Print Curated:
/// - Mobile: < 600px (4-col grid, 16px horizontal padding)
/// - Tablet: 600px..1024px (8-col grid, 24px horizontal padding)
/// - Desktop: >= 1024px (12-col grid, 32px horizontal padding, max-w-7xl)
abstract final class Breakpoints {
  static const double mobileMax = 600.0;
  static const double tabletMax = 1024.0;

  static ScreenSizeClass of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < mobileMax) return ScreenSizeClass.mobile;
    if (width < tabletMax) return ScreenSizeClass.tablet;
    return ScreenSizeClass.desktop;
  }

  static bool isMobile(BuildContext context) =>
      of(context) == ScreenSizeClass.mobile;

  static bool isTablet(BuildContext context) =>
      of(context) == ScreenSizeClass.tablet;

  static bool isDesktop(BuildContext context) =>
      of(context) == ScreenSizeClass.desktop;

  static double horizontalPadding(BuildContext context) {
    return switch (of(context)) {
      ScreenSizeClass.mobile => 16.0,
      ScreenSizeClass.tablet => 24.0,
      ScreenSizeClass.desktop => 32.0,
    };
  }

  static int gridColumns(BuildContext context) {
    return switch (of(context)) {
      ScreenSizeClass.mobile => 2,
      ScreenSizeClass.tablet => 3,
      ScreenSizeClass.desktop => 4,
    };
  }
}

/// Centers content inside `max-w-7xl` (1280px) with responsive horizontal padding.
class MaxWidthContainer extends StatelessWidget {
  const MaxWidthContainer({
    super.key,
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final hPad = Breakpoints.horizontalPadding(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppTokens.maxContentWidth),
        child: Padding(
          padding: padding ?? EdgeInsets.symmetric(horizontal: hPad),
          child: child,
        ),
      ),
    );
  }
}
