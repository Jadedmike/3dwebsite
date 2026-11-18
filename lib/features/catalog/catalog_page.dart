import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/app_locale.dart';
import '../../core/localization/app_strings.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/product.dart';
import '../../services/whatsapp_service.dart';
import '../../shared/widgets/axion_breadcrumb.dart';
import '../../shared/widgets/axion_buttons.dart';
import '../../shared/widgets/axion_product_card.dart';
import '../../shared/widgets/axion_scroll_reveal.dart';
import '../../shared/widgets/axion_section_header.dart';
import '../../state/cart_controller.dart';
import '../../state/favorites_controller.dart';

/// Shared catalog & category page matching Stitch 78ddc0a4 (All Products) and
/// dc3d933e (Figures & Anime), reused identically for all 5 categories.
class CatalogPage extends StatelessWidget {
  const CatalogPage({
    super.key,
    required this.localeController,
    required this.cartController,
    required this.favoritesController,
    required this.products,
    this.activeCategory,
    this.searchQuery = '',
  });

  final LocaleController localeController;
  final CartController cartController;
  final FavoritesController favoritesController;
  final List<Product> products;
  final StoreCategory? activeCategory;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final isArabic = localeController.isArabic;
    final strings = AppStrings(isArabic: isArabic);
    final filteredProducts = products.where((p) {
      if (activeCategory != null) {
        if (activeCategory == StoreCategory.gifts) return false;
        if (p.storeCategory != activeCategory!.slug) return false;
      }
      return p.matchesQuery(searchQuery);
    }).toList(growable: false);
    final pageTitle = activeCategory == null
        ? strings.allProductsTitle
        : strings.categoryLabel(activeCategory!);
    final pageSubtitle = activeCategory == null
        ? strings.bestSellersSubtitle
        : strings.categorySubtitle(activeCategory!);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: MaxWidthContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AxionBreadcrumb(
              isArabic: isArabic,
              segments: [
                BreadcrumbSegment(
                  label: strings.homeTitle,
                  onTap: () => context.go('/'),
                ),
                BreadcrumbSegment(label: pageTitle),
              ],
            ),
            const SizedBox(height: 18),
            AxionSectionHeader(
              isArabic: isArabic,
              title: pageTitle,
              subtitle: pageSubtitle,
            ),
            const SizedBox(height: 20),

            // Category Filter Pills
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _FilterPill(
                  label: strings.filterAll,
                  isArabic: isArabic,
                  selected: activeCategory == null,
                  onTap: () => context.go('/products'),
                ),
                for (final cat in StoreCategory.values)
                  _FilterPill(
                    label: strings.categoryLabel(cat),
                    isArabic: isArabic,
                    selected: activeCategory == cat,
                    onTap: () => context.go('/category/${cat.slug}'),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Product Grid (empty image slots until real JSON is supplied)
            if (filteredProducts.isEmpty)
              const SizedBox.shrink()
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final cols = Breakpoints.gridColumns(context);
                  const spacing = 16.0;
                  final width =
                      (constraints.maxWidth - spacing * (cols - 1)) / cols;
                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: [
                      for (int i = 0; i < filteredProducts.length; i++)
                        SizedBox(
                          width: width,
                          child: AxionScrollReveal(
                            delay: Duration(milliseconds: 45 * (i % 4)),
                            offsetY: 16,
                            child: AxionProductCard(
                              product: filteredProducts[i],
                              isArabic: isArabic,
                              isFavorite: favoritesController
                                  .isFavorite(filteredProducts[i].id),
                              onTap: () => context
                                  .go('/product/${filteredProducts[i].id}'),
                              onFavoriteToggle: () => favoritesController
                                  .toggle(filteredProducts[i].id),
                              onAddToCart: () => cartController
                                  .addItem(filteredProducts[i].id),
                              onWhatsAppOrder: () =>
                                  WhatsAppService.openProductInquiry(
                                product: filteredProducts[i],
                                isArabic: isArabic,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),

            const SizedBox(height: 36),

            // Bottom Custom STL / WhatsApp Banner (deep purple-charcoal gradient from Stitch 78ddc0a4)
            AxionScrollReveal(
              offsetY: 14,
              child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.purple, AppColors.charcoal],
                  begin: AlignmentDirectional.centerStart,
                  end: AlignmentDirectional.centerEnd,
                ),
                borderRadius: BorderRadius.circular(AppTokens.radiusXl),
              ),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: Text(
                      strings.customStlTitle,
                      style: AppTypography.headlineStyle(
                        isArabic: isArabic,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  AxionWhatsAppButton(
                    label: strings.customStlButton,
                    isArabic: isArabic,
                    onPressed: () =>
                        WhatsAppService.openDirectInquiry(isArabic: isArabic),
                  ),
                ],
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.isArabic,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool isArabic;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTokens.radiusPill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.purple : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppTokens.radiusPill),
          border: Border.all(
            color: selected ? AppColors.purple : AppColors.border,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.headlineStyle(
            isArabic: isArabic,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.white : AppColors.charcoal,
          ),
        ),
      ),
    );
  }
}
