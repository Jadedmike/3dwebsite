import 'package:flutter/material.dart';
import '../../core/localization/app_locale.dart';
import '../../core/localization/app_strings.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_typography.dart';

/// Clean structural page body used during Phase 1 before the product JSON
/// and product images are supplied. Contains zero fictional product data.
class PendingStorePage extends StatelessWidget {
  const PendingStorePage({
    super.key,
    required this.localeController,
    required this.title,
    this.subtitle,
  });

  final LocaleController localeController;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final isArabic = localeController.isArabic;
    final strings = AppStrings(isArabic: isArabic);

    return MaxWidthContainer(
      padding: EdgeInsets.symmetric(
        horizontal: Breakpoints.horizontalPadding(context),
        vertical: AppTokens.spaceXl,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppTokens.spaceLg),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppTokens.radiusCard),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: AppTokens.shadowCard,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.headlineStyle(
                isArabic: isArabic,
                fontSize: Breakpoints.isMobile(context) ? 24 : 32,
                fontWeight: FontWeight.w600,
                color: AppColors.charcoal,
              ),
            ),
            const SizedBox(height: AppTokens.spaceSm),
            Text(
              subtitle ?? strings.dataPendingNotice,
              style: AppTypography.bodyStyle(
                isArabic: isArabic,
                fontSize: 15,
                color: AppColors.charcoalMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
