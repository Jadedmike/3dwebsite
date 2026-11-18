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
import '../../shared/widgets/axion_buttons.dart';
import '../../shared/widgets/axion_image_slot.dart';
import '../../shared/widgets/axion_product_card.dart';
import '../../shared/widgets/axion_section_header.dart';
import '../../state/cart_controller.dart';
import '../../state/favorites_controller.dart';

/// Homepage reproducing Stitch c5f4ae8c4c5043b2aa1fbb78e4105b85.
/// Keeps all product/category image slots empty until real assets are supplied.
class HomePage extends StatelessWidget {
  const HomePage({
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
    final isDesktop = Breakpoints.isDesktop(context);
    final isMobile = Breakpoints.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Editorial Hero Card (rounded-3xl white card, 6/6 split)
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 24),
          child: MaxWidthContainer(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(AppTokens.radiusXl),
                border: Border.all(color: AppColors.border, width: 1),
                boxShadow: AppTokens.shadowCard,
              ),
              clipBehavior: Clip.antiAlias,
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(56),
                            child: _HeroTextBlock(
                              isArabic: isArabic,
                              strings: strings,
                              isMobile: false,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: SizedBox(
                            height: 440,
                            child: _HeroImageArea(isArabic: isArabic),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(isMobile ? 28 : 44),
                          child: _HeroTextBlock(
                            isArabic: isArabic,
                            strings: strings,
                            isMobile: isMobile,
                          ),
                        ),
                        SizedBox(
                          height: isMobile ? 260 : 360,
                          child: _HeroImageArea(isArabic: isArabic),
                        ),
                      ],
                    ),
            ),
          ),
        ),

        // 2. 5 Categories Collection Strip (circular image slots inside white cards)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 28),
          child: MaxWidthContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AxionSectionHeader(
                  isArabic: isArabic,
                  badge: strings.collectionsBadge,
                  title: strings.collectionsTitle,
                  actionLabel: strings.viewAllProducts,
                  onActionTap: () => context.go('/products'),
                ),
                const SizedBox(height: 24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final cols = isDesktop
                        ? 5
                        : (Breakpoints.isTablet(context) ? 3 : 2);
                    const spacing = 16.0;
                    final itemWidth =
                        (constraints.maxWidth - spacing * (cols - 1)) / cols;
                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        for (final cat in StoreCategory.values)
                          SizedBox(
                            width: itemWidth,
                            child: _CategoryShowcaseCard(
                              category: cat,
                              isArabic: isArabic,
                              strings: strings,
                              onTap: () => context.go('/category/${cat.slug}'),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // 3. Best Sellers Shelf (3-column empty image grid until JSON arrives)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 28),
          child: MaxWidthContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AxionSectionHeader(
                  isArabic: isArabic,
                  title: strings.bestSellersTitle,
                  subtitle: strings.bestSellersSubtitle,
                  actionLabel: strings.viewAllProducts,
                  onActionTap: () => context.go('/products'),
                ),
                const SizedBox(height: 20),
                if (products.isEmpty)
                  _EmptySlotsGrid(
                    desktopCols: 3,
                    count: 3,
                  )
                else
                  _ProductGrid(
                    products: products.take(3).toList(),
                    isArabic: isArabic,
                    favoritesController: favoritesController,
                    cartController: cartController,
                  ),
              ],
            ),
          ),
        ),

        // 4-8. Five Numbered Category Spotlights (01..05)
        for (int i = 0; i < StoreCategory.values.length; i++)
          _CategorySpotlightSection(
            index: i + 1,
            category: StoreCategory.values[i],
            products: StoreCategory.values[i] == StoreCategory.gifts
                ? const []
                : products
                    .where((p) =>
                        p.storeCategory == StoreCategory.values[i].slug)
                    .take(3)
                    .toList(growable: false),
            isArabic: isArabic,
            strings: strings,
            favoritesController: favoritesController,
            cartController: cartController,
            onViewCategory: () =>
                context.go('/category/${StoreCategory.values[i].slug}'),
          ),

        // 9. Centered 3-Step WhatsApp Ordering Section
        Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.symmetric(vertical: 48),
          decoration: const BoxDecoration(
            color: AppColors.purpleLight,
            border: Border(
              top: BorderSide(color: AppColors.border, width: 1),
              bottom: BorderSide(color: AppColors.border, width: 1),
            ),
          ),
          child: MaxWidthContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.mintTint,
                    borderRadius: BorderRadius.circular(AppTokens.radiusPill),
                  ),
                  child: Text(
                    strings.waStepsBadge,
                    style: AppTypography.headlineStyle(
                      isArabic: isArabic,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.mintDeepText,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  strings.waStepsTitle,
                  textAlign: TextAlign.center,
                  style: AppTypography.headlineStyle(
                    isArabic: isArabic,
                    fontSize: isMobile ? 24 : 30,
                    fontWeight: FontWeight.w700,
                    color: AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  strings.waStepsSubtitle,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyStyle(
                    isArabic: isArabic,
                    fontSize: 14,
                    color: AppColors.charcoalMuted,
                  ),
                ),
                const SizedBox(height: 28),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final cols = isMobile ? 1 : 3;
                    const spacing = 16.0;
                    final width =
                        (constraints.maxWidth - spacing * (cols - 1)) / cols;
                    final steps = [
                      (
                        strings.waStep1Title,
                        strings.waStep1Desc,
                        AppColors.purpleLight,
                        AppColors.purple,
                      ),
                      (
                        strings.waStep2Title,
                        strings.waStep2Desc,
                        AppColors.mintTint,
                        AppColors.mintDeepText,
                      ),
                      (
                        strings.waStep3Title,
                        strings.waStep3Desc,
                        AppColors.brownContainer.withValues(alpha: 0.4),
                        AppColors.brown,
                      ),
                    ];
                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        for (int i = 0; i < steps.length; i++)
                          SizedBox(
                            width: width,
                            child: _WhatsAppStepCard(
                              stepNumber: '${i + 1}',
                              title: steps[i].$1,
                              description: steps[i].$2,
                              badgeBg: steps[i].$3,
                              badgeFg: steps[i].$4,
                              isArabic: isArabic,
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                AxionPrimaryButton(
                  label: strings.orderViaWhatsApp,
                  isArabic: isArabic,
                  icon: Icons.chat_bubble_outline_rounded,
                  onPressed: () =>
                      WhatsAppService.openDirectInquiry(isArabic: isArabic),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroTextBlock extends StatelessWidget {
  const _HeroTextBlock({
    required this.isArabic,
    required this.strings,
    required this.isMobile,
  });

  final bool isArabic;
  final AppStrings strings;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.purple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTokens.radiusPill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
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
              Flexible(
                child: Text(
                  strings.heroBadge,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.headlineStyle(
                    isArabic: false,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.purple,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          strings.heroTitle,
          style: AppTypography.headlineStyle(
            isArabic: isArabic,
            fontSize: isMobile ? 30 : 44,
            fontWeight: FontWeight.w700,
            height: 1.18,
            color: AppColors.charcoal,
          ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Text(
            strings.heroSubtitle,
            style: AppTypography.bodyStyle(
              isArabic: isArabic,
              fontSize: 15,
              height: 1.65,
              color: AppColors.charcoalMuted,
            ),
          ),
        ),
        const SizedBox(height: 22),
        AxionPrimaryButton(
          label: strings.browseCollections,
          isArabic: isArabic,
          icon: isArabic
              ? Icons.arrow_back_rounded
              : Icons.arrow_forward_rounded,
          onPressed: () => context.go('/products'),
        ),
      ],
    );
  }
}

class _HeroImageArea extends StatelessWidget {
  const _HeroImageArea({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const AxionImageSlot(aspectRatio: 16 / 10, borderRadius: 0),
        PositionedDirectional(
          bottom: 16,
          start: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.surfaceGlass,
              borderRadius: BorderRadius.circular(AppTokens.radiusPill),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
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
                Text(
                  'Bespoke Atelier Collection',
                  style: AppTypography.headlineStyle(
                    isArabic: false,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.charcoal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryShowcaseCard extends StatelessWidget {
  const _CategoryShowcaseCard({
    required this.category,
    required this.isArabic,
    required this.strings,
    required this.onTap,
  });

  final StoreCategory category;
  final bool isArabic;
  final AppStrings strings;
  final VoidCallback onTap;

  static String _categoryImageAsset(StoreCategory category) {
    return switch (category) {
      StoreCategory.figuresAnime =>
        'assets/images/categories/figures_anime.png.webp',
      StoreCategory.geometricOffice =>
        'assets/images/categories/geometric_office.png.webp',
      StoreCategory.homeDecorKitchen =>
        'assets/images/categories/home_decor_kitchen.png.jpg',
      StoreCategory.gifts => 'assets/images/categories/gifts.png.webp',
      StoreCategory.keychains =>
        'assets/images/categories/keychains.png.webp',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppTokens.radiusCard),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppTokens.shadowCard,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTokens.radiusCard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 72,
              height: 72,
              child: AxionImageSlot(
                assetPath: _categoryImageAsset(category),
                aspectRatio: 1.0,
                borderRadius: AppTokens.radiusPill,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              strings.categoryLabel(category),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.headlineStyle(
                isArabic: isArabic,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.charcoal,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              strings.categorySubtitle(category),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyStyle(
                isArabic: isArabic,
                fontSize: 11.5,
                color: AppColors.charcoalMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategorySpotlightSection extends StatelessWidget {
  const _CategorySpotlightSection({
    required this.index,
    required this.category,
    required this.products,
    required this.isArabic,
    required this.strings,
    required this.favoritesController,
    required this.cartController,
    required this.onViewCategory,
  });

  final int index;
  final StoreCategory category;
  final List<Product> products;
  final bool isArabic;
  final AppStrings strings;
  final FavoritesController favoritesController;
  final CartController cartController;
  final VoidCallback onViewCategory;

  @override
  Widget build(BuildContext context) {
    final badge = '0$index / ${strings.categoryLabel(category)}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: MaxWidthContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AxionSectionHeader(
              isArabic: isArabic,
              badge: badge,
              title: strings.categoryLabel(category),
              subtitle: strings.categorySubtitle(category),
              actionLabel: strings.viewAllProducts,
              onActionTap: onViewCategory,
            ),
            const SizedBox(height: 20),
            if (category == StoreCategory.gifts)
              const SizedBox.shrink()
            else if (products.isEmpty)
              const _EmptySlotsGrid(desktopCols: 3, count: 3)
            else
              _ProductGrid(
                products: products,
                isArabic: isArabic,
                favoritesController: favoritesController,
                cartController: cartController,
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptySlotsGrid extends StatelessWidget {
  const _EmptySlotsGrid({required this.desktopCols, required this.count});

  final int desktopCols;
  final int count;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = Breakpoints.isDesktop(context)
            ? desktopCols
            : (Breakpoints.isTablet(context) ? 2 : 2);
        const spacing = 16.0;
        final width = (constraints.maxWidth - spacing * (cols - 1)) / cols;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (int i = 0; i < count; i++)
              SizedBox(
                width: width,
                child: const AxionImageSlot(aspectRatio: 1.0),
              ),
          ],
        );
      },
    );
  }
}

class _WhatsAppStepCard extends StatelessWidget {
  const _WhatsAppStepCard({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.badgeBg,
    required this.badgeFg,
    required this.isArabic,
  });

  final String stepNumber;
  final String title;
  final String description;
  final Color badgeBg;
  final Color badgeFg;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppTokens.radiusCard),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppTokens.shadowCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: badgeBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              stepNumber,
              style: AppTypography.headlineStyle(
                isArabic: false,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: badgeFg,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.headlineStyle(
              isArabic: isArabic,
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              color: AppColors.charcoal,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTypography.bodyStyle(
              isArabic: isArabic,
              fontSize: 12.5,
              height: 1.55,
              color: AppColors.charcoalMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({
    required this.products,
    required this.isArabic,
    required this.favoritesController,
    required this.cartController,
  });

  final List<Product> products;
  final bool isArabic;
  final FavoritesController favoritesController;
  final CartController cartController;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = Breakpoints.gridColumns(context);
        const spacing = 16.0;
        final width = (constraints.maxWidth - spacing * (cols - 1)) / cols;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final product in products)
              SizedBox(
                width: width,
                child: AxionProductCard(
                  product: product,
                  isArabic: isArabic,
                  isFavorite: favoritesController.isFavorite(product.id),
                  onTap: () => context.go('/product/${product.id}'),
                  onFavoriteToggle: () => favoritesController.toggle(product.id),
                  onAddToCart: () => cartController.addItem(product.id),
                  onWhatsAppOrder: () =>
                      WhatsAppService.openDirectInquiry(isArabic: isArabic),
                ),
              ),
          ],
        );
      },
    );
  }
}
