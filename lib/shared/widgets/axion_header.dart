import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/localization/app_locale.dart';
import '../../core/localization/app_strings.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_typography.dart';
import 'axion_logo.dart';
import 'axion_mascots.dart';

/// Top announcement bar + sticky frosted-glass header matching Stitch c5f4ae8c.
class AxionHeader extends StatelessWidget {
  const AxionHeader({
    super.key,
    required this.localeController,
    required this.favoritesCount,
    required this.cartCount,
    required this.onHomeTap,
    required this.onFavoritesTap,
    required this.onCartTap,
    required this.onWhatsAppTap,
    this.onMenuTap,
    this.onSearchSubmitted,
  });

  final LocaleController localeController;
  final int favoritesCount;
  final int cartCount;
  final VoidCallback onHomeTap;
  final VoidCallback onFavoritesTap;
  final VoidCallback onCartTap;
  final VoidCallback onWhatsAppTap;
  final VoidCallback? onMenuTap;
  final ValueChanged<String>? onSearchSubmitted;

  @override
  Widget build(BuildContext context) {
    final isArabic = localeController.isArabic;
    final strings = AppStrings(isArabic: isArabic);
    final sizeClass = Breakpoints.of(context);
    final isMobile = sizeClass == ScreenSizeClass.mobile;
    final isDesktop = sizeClass == ScreenSizeClass.desktop;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
        // 1. Top Announcement Bar (#F3EBF2) with language switcher pill
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: const BoxDecoration(
            color: Color(0xFFF3EBF2),
            border: Border(
              bottom: BorderSide(color: AppColors.border, width: 1),
            ),
          ),
          child: MaxWidthContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.mint,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          strings.announcementText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodyStyle(
                            isArabic: isArabic,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.purple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _TopLanguageSwitch(localeController: localeController),
              ],
            ),
          ),
        ),

        // 2. Sticky Frosted-Glass Main Header
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              height: AppTokens.headerHeight,
              decoration: const BoxDecoration(
                color: AppColors.surfaceGlass,
                border: Border(
                  bottom: BorderSide(color: AppColors.border, width: 1),
                ),
                boxShadow: AppTokens.shadowHeader,
              ),
              child: MaxWidthContainer(
                child: Row(
                  children: [
                    // Start Side: Menu trigger (mobile/tablet) + Search input ONLY
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (!isDesktop && onMenuTap != null) ...[
                            _HeaderCircleButton(
                              icon: Icons.menu_rounded,
                              tooltip: isArabic ? 'القائمة' : 'Menü',
                              onTap: onMenuTap!,
                            ),
                            const SizedBox(width: 8),
                          ],
                          if (!isMobile)
                            Flexible(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: isDesktop ? 184 : 164,
                                  maxHeight: 36,
                                ),
                                child: TextField(
                                  onSubmitted: onSearchSubmitted,
                                  style: AppTypography.bodyStyle(
                                    isArabic: isArabic,
                                    fontSize: 12,
                                    color: AppColors.charcoal,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: strings.searchPlaceholder,
                                    hintStyle: AppTypography.bodyStyle(
                                      isArabic: isArabic,
                                      fontSize: 12,
                                      color: AppColors.charcoalMuted.withValues(
                                        alpha: 0.7,
                                      ),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.search_rounded,
                                      size: 16,
                                      color: AppColors.charcoalMuted,
                                    ),
                                    prefixIconConstraints: const BoxConstraints(
                                      minWidth: 32,
                                      minHeight: 32,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Center: Official Complete Brand Logo
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: AxionLogo(
                        height: isDesktop ? 54 : (isMobile ? 38 : 50),
                        onTap: onHomeTap,
                      ),
                    ),

                    // End Side: WhatsApp Direct, Favorites, Cart
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (!isMobile) ...[
                                _WhatsAppHeaderPill(
                                  label: strings.orderWaHeader,
                                  isArabic: isArabic,
                                  showLabel: isDesktop,
                                  onTap: onWhatsAppTap,
                                ),
                                const SizedBox(width: 6),
                                const CreeperHeaderMascot(),
                                const SizedBox(width: 10),
                              ],
                              _HeaderCircleButton(
                                icon: Icons.favorite_border_rounded,
                                tooltip: strings.favoritesTitle,
                                badgeCount: favoritesCount,
                                badgeColor: AppColors.purple,
                                onTap: onFavoritesTap,
                              ),
                              const SizedBox(width: 10),
                              _HeaderCircleButton(
                                icon: Icons.shopping_bag_outlined,
                                tooltip: strings.cartTitle,
                                badgeCount: cartCount,
                                badgeColor: AppColors.mint,
                                onTap: onCartTap,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
        ),
        Positioned(
          bottom: isDesktop ? -27 : (isMobile ? -19 : -22),
          left: isDesktop ? 380 : (isMobile ? 96 : 238),
          child: const SearchBarMascot(),
        ),
      ],
    );
  }
}

class _TopLanguageSwitch extends StatelessWidget {
  const _TopLanguageSwitch({required this.localeController});

  final LocaleController localeController;

  @override
  Widget build(BuildContext context) {
    final isArabic = localeController.isArabic;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppTokens.radiusPill),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => localeController.setLanguage(AppLanguage.ar),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Text(
                'العربية',
                style: AppTypography.headlineStyle(
                  isArabic: true,
                  fontSize: 11,
                  fontWeight: isArabic ? FontWeight.w700 : FontWeight.w500,
                  color:
                      isArabic ? AppColors.purple : AppColors.charcoalMuted,
                ),
              ),
            ),
          ),
          const Text(
            '|',
            style: TextStyle(color: AppColors.border, fontSize: 11),
          ),
          InkWell(
            onTap: () => localeController.setLanguage(AppLanguage.tr),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Text(
                'Türkçe',
                style: AppTypography.headlineStyle(
                  isArabic: false,
                  fontSize: 11,
                  fontWeight: !isArabic ? FontWeight.w700 : FontWeight.w500,
                  color:
                      !isArabic ? AppColors.purple : AppColors.charcoalMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WhatsAppHeaderPill extends StatelessWidget {
  const _WhatsAppHeaderPill({
    required this.label,
    required this.isArabic,
    required this.showLabel,
    required this.onTap,
  });

  final String label;
  final bool isArabic;
  final bool showLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTokens.radiusPill),
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.mintTint,
          borderRadius: BorderRadius.circular(AppTokens.radiusPill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 16,
              color: AppColors.mint,
            ),
            if (showLabel) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTypography.headlineStyle(
                  isArabic: isArabic,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.charcoal,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HeaderCircleButton extends StatelessWidget {
  const _HeaderCircleButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.badgeCount = 0,
    this.badgeColor = AppColors.purple,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final int badgeCount;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppTokens.radiusPill),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Icon(icon, size: 18, color: AppColors.charcoal),
            ),
          ),
          if (badgeCount > 0)
            PositionedDirectional(
              top: -4,
              end: -4,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  badgeCount > 99 ? '99+' : '$badgeCount',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
