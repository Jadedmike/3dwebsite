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

/// Favorites page reproducing Stitch bc6085a8cfd440738c24b804f3b444fb.
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({
    super.key,
    required this.localeController,
    required this.cartController,
    required this.favoritesController,
    required this.products,
  });

  final LocaleController localeController;
  final CartController cartController;
  final FavoritesController favoritesController;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    final isArabic = localeController.isArabic;
    final strings = AppStrings(isArabic: isArabic);
    final favoriteProducts = products
        .where((p) => favoritesController.isFavorite(p.id))
        .toList(growable: false);

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
                BreadcrumbSegment(label: strings.favoritesTitle),
              ],
            ),
            const SizedBox(height: 18),
            AxionSectionHeader(
              isArabic: isArabic,
              title: strings.favoritesTitle,
            ),
            const SizedBox(height: 24),
            if (favoriteProducts.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
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
                      strings.favoritesEmptyNotice,
                      style: AppTypography.bodyStyle(
                        isArabic: isArabic,
                        fontSize: 15,
                        color: AppColors.charcoalMuted,
                      ),
                    ),
                    const SizedBox(height: 18),
                    AxionPrimaryButton(
                      label: strings.viewAllProducts,
                      isArabic: isArabic,
                      onPressed: () => context.go('/products'),
                    ),
                  ],
                ),
              )
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
                      for (int i = 0; i < favoriteProducts.length; i++)
                        SizedBox(
                          width: width,
                          child: AxionScrollReveal(
                            delay: Duration(milliseconds: 45 * (i % 4)),
                            offsetY: 16,
                            child: AxionProductCard(
                              product: favoriteProducts[i],
                              isArabic: isArabic,
                              isFavorite: true,
                              onTap: () => context
                                  .go('/product/${favoriteProducts[i].id}'),
                              onFavoriteToggle: () => favoritesController
                                  .toggle(favoriteProducts[i].id),
                              onAddToCart: () => cartController
                                  .addItem(favoriteProducts[i].id),
                              onWhatsAppOrder: () =>
                                  WhatsAppService.openDirectInquiry(
                                isArabic: isArabic,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
