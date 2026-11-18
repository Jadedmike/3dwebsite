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
import '../../shared/widgets/axion_section_header.dart';
import '../../state/cart_controller.dart';

/// Shopping Cart page reproducing Stitch 805a8d1d93c24bbd8fa2accee5e8f050.
class CartPage extends StatelessWidget {
  const CartPage({
    super.key,
    required this.localeController,
    required this.cartController,
    required this.products,
  });

  final LocaleController localeController;
  final CartController cartController;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    final isArabic = localeController.isArabic;
    final strings = AppStrings(isArabic: isArabic);
    final isDesktop = Breakpoints.isDesktop(context);
    final items = cartController.items;

    final productMap = {for (final p in products) p.id: p};

    final itemsPanel = items.isEmpty
        ? Container(
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
                  strings.cartEmptyNotice,
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
        : Column(
            children: [
              for (final item in items) ...[
                _CartItemCard(
                  item: item,
                  product: productMap[item.productId],
                  isArabic: isArabic,
                  onDecrement: () => cartController.updateQuantity(
                    item.productId,
                    item.quantity - 1,
                    selectedColor: item.selectedColor,
                  ),
                  onIncrement: () => cartController.updateQuantity(
                    item.productId,
                    item.quantity + 1,
                    selectedColor: item.selectedColor,
                  ),
                  onRemove: () => cartController.removeItem(
                    item.productId,
                    selectedColor: item.selectedColor,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ],
          );

    final summaryPanel = _OrderSummaryCard(
      isArabic: isArabic,
      strings: strings,
      totalCount: cartController.totalCount,
      onCheckout: () => WhatsAppService.openCartCheckout(
        items: items,
        productMap: productMap,
        isArabic: isArabic,
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
                BreadcrumbSegment(label: strings.cartTitle),
              ],
            ),
            const SizedBox(height: 18),
            AxionSectionHeader(
              isArabic: isArabic,
              title: strings.cartTitle,
            ),
            const SizedBox(height: 24),
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 8, child: itemsPanel),
                  const SizedBox(width: 28),
                  Expanded(flex: 4, child: summaryPanel),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  itemsPanel,
                  const SizedBox(height: 20),
                  summaryPanel,
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({
    required this.item,
    required this.product,
    required this.isArabic,
    required this.onDecrement,
    required this.onIncrement,
    required this.onRemove,
  });

  final CartItem item;
  final Product? product;
  final bool isArabic;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final imagePath = (product != null && product!.imagePaths.isNotEmpty)
        ? product!.imagePaths.first
        : null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppTokens.radiusCard),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppTokens.shadowCard,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 84,
            child: AxionImageSlot(
              assetPath: imagePath,
              aspectRatio: 1.0,
              borderRadius: AppTokens.radiusLg,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product?.localizedName(isArabic: isArabic) ?? item.productId,
                  style: AppTypography.headlineStyle(
                    isArabic: isArabic,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    IconButton(
                      onPressed: onDecrement,
                      icon: const Icon(Icons.remove_circle_outline, size: 20),
                    ),
                    Text(
                      '${item.quantity}',
                      style: AppTypography.headlineStyle(
                        isArabic: false,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      onPressed: onIncrement,
                      icon: const Icon(Icons.add_circle_outline, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.charcoalMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({
    required this.isArabic,
    required this.strings,
    required this.totalCount,
    required this.onCheckout,
  });

  final bool isArabic;
  final AppStrings strings;
  final int totalCount;
  final VoidCallback onCheckout;

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
          Text(
            strings.orderSummary,
            style: AppTypography.headlineStyle(
              isArabic: isArabic,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.charcoal,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                strings.itemsCountLabel,
                style: AppTypography.bodyStyle(
                  isArabic: isArabic,
                  fontSize: 14,
                  color: AppColors.charcoalMuted,
                ),
              ),
              Text(
                '$totalCount',
                style: AppTypography.headlineStyle(
                  isArabic: false,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Divider(height: 24, color: AppColors.border),
          AxionWhatsAppButton(
            label: strings.checkoutWhatsApp,
            isArabic: isArabic,
            fullWidth: true,
            onPressed: totalCount > 0 ? onCheckout : null,
          ),
          const SizedBox(height: 12),
          Text(
            strings.noAccountNeededNote,
            style: AppTypography.bodyStyle(
              isArabic: isArabic,
              fontSize: 12,
              color: AppColors.charcoalMuted,
            ),
          ),
        ],
      ),
    );
  }
}
