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
import '../../shared/widgets/axion_image_slot.dart';
import '../../shared/widgets/axion_scroll_reveal.dart';
import '../../state/cart_controller.dart';
import '../../state/favorites_controller.dart';

/// Product Details page reproducing Stitch 57d1f0f5dcba4098a99d4ab739dd6eeb.
/// Keeps image slots empty and fields unbound until real JSON & assets arrive.
class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({
    super.key,
    required this.localeController,
    required this.cartController,
    required this.favoritesController,
    required this.productId,
    this.product,
  });

  final LocaleController localeController;
  final CartController cartController;
  final FavoritesController favoritesController;
  final String productId;
  final Product? product;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _selectedImageIndex = 0;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final isArabic = widget.localeController.isArabic;
    final strings = AppStrings(isArabic: isArabic);
    final isDesktop = Breakpoints.isDesktop(context);
    final product = widget.product;

    final gallery = AxionScrollReveal(
      offsetY: 14,
      child: _GalleryColumn(
        imagePaths: product?.imagePaths ?? const [],
        selectedIndex: _selectedImageIndex,
        onSelect: (idx) => setState(() => _selectedImageIndex = idx),
      ),
    );

    final details = AxionScrollReveal(
      offsetY: 14,
      delay: const Duration(milliseconds: 60),
      child: _DetailsColumn(
      isArabic: isArabic,
      strings: strings,
      product: product,
      productId: widget.productId,
      quantity: _quantity,
      isFavorite: widget.favoritesController.isFavorite(widget.productId),
      onDecrement: () {
        if (_quantity > 1) setState(() => _quantity--);
      },
      onIncrement: () => setState(() => _quantity++),
      onAddToCart: product == null
          ? null
          : () async {
              for (int i = 0; i < _quantity; i++) {
                await widget.cartController.addItem(product.id);
              }
            },
      onToggleFavorite: product == null
          ? null
          : () => widget.favoritesController.toggle(product.id),
      onWhatsAppOrder: () => product != null
          ? WhatsAppService.openProductInquiry(
              product: product,
              isArabic: isArabic,
              quantity: _quantity,
            )
          : WhatsAppService.openDirectInquiry(isArabic: isArabic),
      ),
    );

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
                BreadcrumbSegment(
                  label: strings.allProductsTitle,
                  onTap: () => context.go('/products'),
                ),
                BreadcrumbSegment(
                  label: product?.localizedName(isArabic: isArabic) ??
                      strings.productDetailsTitle,
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: gallery),
                  const SizedBox(width: 40),
                  Expanded(flex: 6, child: details),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  gallery,
                  const SizedBox(height: 28),
                  details,
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _GalleryColumn extends StatelessWidget {
  const _GalleryColumn({
    required this.imagePaths,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<String> imagePaths;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final mainPath = (imagePaths.isNotEmpty && selectedIndex < imagePaths.length)
        ? imagePaths[selectedIndex]
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AxionImageSlot(assetPath: mainPath, aspectRatio: 1.0),
        const SizedBox(height: 12),
        Row(
          children: [
            for (int i = 0; i < 4; i++) ...[
              if (i > 0) const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: () => onSelect(i),
                  borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppTokens.radiusMd),
                      border: Border.all(
                        color: selectedIndex == i
                            ? AppColors.purple
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: AxionImageSlot(
                      assetPath:
                          i < imagePaths.length ? imagePaths[i] : null,
                      aspectRatio: 1.0,
                      borderRadius: AppTokens.radiusMd,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _DetailsColumn extends StatelessWidget {
  const _DetailsColumn({
    required this.isArabic,
    required this.strings,
    required this.product,
    required this.productId,
    required this.quantity,
    required this.isFavorite,
    required this.onDecrement,
    required this.onIncrement,
    required this.onAddToCart,
    required this.onToggleFavorite,
    required this.onWhatsAppOrder,
  });

  final bool isArabic;
  final AppStrings strings;
  final Product? product;
  final String productId;
  final int quantity;
  final bool isFavorite;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback? onAddToCart;
  final VoidCallback? onToggleFavorite;
  final VoidCallback onWhatsAppOrder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppTokens.radiusCard),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppTokens.shadowCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (product != null && product!.category.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.purpleLight,
                borderRadius: BorderRadius.circular(AppTokens.radiusPill),
              ),
              child: Text(
                product!.category,
                style: AppTypography.headlineStyle(
                  isArabic: false,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.purple,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Text(
            product?.localizedName(isArabic: isArabic) ??
                strings.productDetailsTitle,
            style: AppTypography.headlineStyle(
              isArabic: isArabic,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.charcoal,
            ),
          ),
          const SizedBox(height: 10),
          if (product?.price != null) ...[
            Text(
              '${product!.price!.toStringAsFixed(2)} ${product!.currency ?? ''}'
                  .trim(),
              style: AppTypography.headlineStyle(
                isArabic: false,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.purple,
              ),
            ),
            const SizedBox(height: 14),
          ],
          Text(
            product?.localizedDescription(isArabic: isArabic) ??
                strings.dataPendingNotice,
            style: AppTypography.bodyStyle(
              isArabic: isArabic,
              fontSize: 14.5,
              height: 1.65,
              color: AppColors.charcoalMuted,
            ),
          ),
          const SizedBox(height: 20),

          // Technical Fabrication Specs Grid
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppTokens.radiusLg),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Column(
              children: [
                _SpecRow(
                  label: strings.specMaterial,
                  value: product?.material ?? '—',
                  isArabic: isArabic,
                ),
                const Divider(height: 16, color: AppColors.border),
                _SpecRow(
                  label: strings.specPrintTime,
                  value: product?.estimatedPrintTime ?? '—',
                  isArabic: isArabic,
                ),
                const Divider(height: 16, color: AppColors.border),
                _SpecRow(
                  label: strings.specWeight,
                  value: product != null ? '${product!.weightGrams} g' : '—',
                  isArabic: isArabic,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // Quantity & Action Buttons
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppTokens.radiusPill),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: onDecrement,
                      icon: const Icon(Icons.remove_rounded, size: 18),
                      constraints:
                          const BoxConstraints(minWidth: 36, minHeight: 36),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '$quantity',
                        style: AppTypography.headlineStyle(
                          isArabic: false,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onIncrement,
                      icon: const Icon(Icons.add_rounded, size: 18),
                      constraints:
                          const BoxConstraints(minWidth: 36, minHeight: 36),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AxionSecondaryButton(
                  label: strings.addToCart,
                  isArabic: isArabic,
                  icon: Icons.shopping_bag_outlined,
                  fullWidth: true,
                  onPressed: onAddToCart,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AxionWhatsAppButton(
            label: strings.orderViaWhatsApp,
            isArabic: isArabic,
            fullWidth: true,
            onPressed: onWhatsAppOrder,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: AxionOutlinedButton(
              label: strings.addToFavorites,
              isArabic: isArabic,
              icon: isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              borderColor: AppColors.purple,
              onPressed: onToggleFavorite,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({
    required this.label,
    required this.value,
    required this.isArabic,
  });

  final String label;
  final String value;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyStyle(
            isArabic: isArabic,
            fontSize: 13,
            color: AppColors.charcoalMuted,
          ),
        ),
        Text(
          value,
          style: AppTypography.headlineStyle(
            isArabic: false,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.charcoal,
          ),
        ),
      ],
    );
  }
}
