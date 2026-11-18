import 'package:flutter/material.dart';
import '../../core/config/app_config.dart';
import '../../core/localization/app_locale.dart';
import '../../core/localization/app_strings.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_typography.dart';
import 'axion_buttons.dart';
import 'axion_logo.dart';

/// Shared footer matching Stitch c5f4ae8c4c5043b2aa1fbb78e4105b85.
class AxionFooter extends StatelessWidget {
  const AxionFooter({
    super.key,
    required this.localeController,
    required this.onHomeTap,
    required this.onAllProductsTap,
    required this.onCategoryTap,
    required this.onWhatsAppTap,
  });

  final LocaleController localeController;
  final VoidCallback onHomeTap;
  final VoidCallback onAllProductsTap;
  final ValueChanged<StoreCategory> onCategoryTap;
  final VoidCallback onWhatsAppTap;

  @override
  Widget build(BuildContext context) {
    final isArabic = localeController.isArabic;
    final strings = AppStrings(isArabic: isArabic);
    final isDesktop = Breakpoints.isDesktop(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: AppTokens.spaceXl),
      padding: const EdgeInsets.symmetric(vertical: AppTokens.space2Xl),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: MaxWidthContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!isDesktop) ...[
              _BrandBioColumn(
                isArabic: isArabic,
                strings: strings,
                onHomeTap: onHomeTap,
                onWhatsAppTap: onWhatsAppTap,
              ),
              const SizedBox(height: 28),
              _CategoriesColumn(
                isArabic: isArabic,
                strings: strings,
                onAllProductsTap: onAllProductsTap,
                onCategoryTap: onCategoryTap,
              ),
              const SizedBox(height: 28),
              _RegionLanguageColumn(
                localeController: localeController,
                strings: strings,
              ),
            ] else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: _BrandBioColumn(
                      isArabic: isArabic,
                      strings: strings,
                      onHomeTap: onHomeTap,
                      onWhatsAppTap: onWhatsAppTap,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 4,
                    child: _CategoriesColumn(
                      isArabic: isArabic,
                      strings: strings,
                      onAllProductsTap: onAllProductsTap,
                      onCategoryTap: onCategoryTap,
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 3,
                    child: _RegionLanguageColumn(
                      localeController: localeController,
                      strings: strings,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 32),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 12,
              spacing: 16,
              children: [
                Text(
                  strings.copyright,
                  style: AppTypography.bodyStyle(
                    isArabic: false,
                    fontSize: 12,
                    color: AppColors.charcoalMuted,
                  ),
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 6,
                  children: [
                    Text(
                      strings.footerPrivacy,
                      style: AppTypography.bodyStyle(
                        isArabic: isArabic,
                        fontSize: 12,
                        color: AppColors.charcoalMuted,
                      ),
                    ),
                    const Text(
                      '•',
                      style: TextStyle(color: AppColors.charcoalMuted),
                    ),
                    Text(
                      strings.footerTerms,
                      style: AppTypography.bodyStyle(
                        isArabic: isArabic,
                        fontSize: 12,
                        color: AppColors.charcoalMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandBioColumn extends StatelessWidget {
  const _BrandBioColumn({
    required this.isArabic,
    required this.strings,
    required this.onHomeTap,
    required this.onWhatsAppTap,
  });

  final bool isArabic;
  final AppStrings strings;
  final VoidCallback onHomeTap;
  final VoidCallback onWhatsAppTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AxionLogo(height: 32, onTap: onHomeTap),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Text(
            strings.footerBio,
            style: AppTypography.bodyStyle(
              isArabic: isArabic,
              fontSize: 12.5,
              height: 1.65,
              color: AppColors.charcoalMuted,
            ),
          ),
        ),
        const SizedBox(height: 16),
        AxionWhatsAppButton(
          label:
              '${strings.whatsappDirectPrefix} ${AppConfig.whatsappDisplayNumber}',
          isArabic: isArabic,
          backgroundColor: AppColors.mint,
          onPressed: onWhatsAppTap,
        ),
      ],
    );
  }
}

class _CategoriesColumn extends StatelessWidget {
  const _CategoriesColumn({
    required this.isArabic,
    required this.strings,
    required this.onAllProductsTap,
    required this.onCategoryTap,
  });

  final bool isArabic;
  final AppStrings strings;
  final VoidCallback onAllProductsTap;
  final ValueChanged<StoreCategory> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.footerNavTitle,
          style: AppTypography.headlineStyle(
            isArabic: isArabic,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.purple,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),
        _FooterLink(
          label: strings.allProductsTitle,
          isArabic: isArabic,
          onTap: onAllProductsTap,
        ),
        for (final cat in StoreCategory.values)
          _FooterLink(
            label: strings.categoryLabel(cat),
            isArabic: isArabic,
            onTap: () => onCategoryTap(cat),
          ),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({
    required this.label,
    required this.isArabic,
    required this.onTap,
  });

  final String label;
  final bool isArabic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          label,
          style: AppTypography.bodyStyle(
            isArabic: isArabic,
            fontSize: 12.5,
            color: AppColors.charcoalMuted,
          ),
        ),
      ),
    );
  }
}

class _RegionLanguageColumn extends StatelessWidget {
  const _RegionLanguageColumn({
    required this.localeController,
    required this.strings,
  });

  final LocaleController localeController;
  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final isArabic = localeController.isArabic;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.footerRegionTitle,
          style: AppTypography.headlineStyle(
            isArabic: isArabic,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.purple,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          strings.footerRegionDesc,
          style: AppTypography.bodyStyle(
            isArabic: isArabic,
            fontSize: 12.5,
            height: 1.6,
            color: AppColors.charcoalMuted,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _LangChip(
              label: 'العربية (RTL)',
              selected: isArabic,
              onTap: () => localeController.setLanguage(AppLanguage.ar),
            ),
            _LangChip(
              label: 'Türkçe (LTR)',
              selected: !isArabic,
              onTap: () => localeController.setLanguage(AppLanguage.tr),
            ),
          ],
        ),
      ],
    );
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTokens.radiusPill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.purple : AppColors.background,
          borderRadius: BorderRadius.circular(AppTokens.radiusPill),
          border: Border.all(
            color: selected ? AppColors.purple : AppColors.border,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.white : AppColors.charcoal,
          ),
        ),
      ),
    );
  }
}
