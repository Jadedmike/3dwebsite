import 'package:flutter/material.dart';
import '../../core/localization/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/product.dart';
import 'axion_image_slot.dart';

/// Consistent Stitch-faithful Product Card.
/// Keeps image slots empty when no product image path is supplied, and never
/// invents prices or product data.
class AxionProductCard extends StatelessWidget {
  const AxionProductCard({
    super.key,
    required this.product,
    required this.isArabic,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.onAddToCart,
    required this.onWhatsAppOrder,
  });

  final Product product;
  final bool isArabic;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onAddToCart;
  final VoidCallback onWhatsAppOrder;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(isArabic: isArabic);
    final imagePath =
        product.imagePaths.isNotEmpty ? product.imagePaths.first : null;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppTokens.radiusCard),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppTokens.shadowCard,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Area with Favorite Toggle
            Stack(
              children: [
                AxionImageSlot(
                  assetPath: imagePath,
                  aspectRatio: 1.0,
                  borderRadius: 0,
                ),
                PositionedDirectional(
                  top: 10,
                  end: 10,
                  child: InkWell(
                    onTap: onFavoriteToggle,
                    borderRadius: BorderRadius.circular(AppTokens.radiusPill),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceGlass,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border, width: 1),
                      ),
                      child: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 17,
                        color: isFavorite
                            ? AppColors.purple
                            : AppColors.charcoal,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Metadata & Actions
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.material.isNotEmpty) ...[
                    Text(
                      product.material,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.headlineStyle(
                        isArabic: false,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brown,
                        letterSpacing: 0.7,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                  Text(
                    product.localizedName(isArabic: isArabic),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.headlineStyle(
                      isArabic: isArabic,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.charcoal,
                    ),
                  ),
                  if (product.price != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      '${product.price!.toStringAsFixed(2)} ${product.currency ?? ''}'
                          .trim(),
                      style: AppTypography.headlineStyle(
                        isArabic: false,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.purple,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: onAddToCart,
                          borderRadius:
                              BorderRadius.circular(AppTokens.radiusPill),
                          child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.purple,
                              borderRadius:
                                  BorderRadius.circular(AppTokens.radiusPill),
                            ),
                            child: Text(
                              strings.addToCart,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.headlineStyle(
                                isArabic: isArabic,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: onWhatsAppOrder,
                        borderRadius:
                            BorderRadius.circular(AppTokens.radiusPill),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.whatsappGreen,
                            borderRadius:
                                BorderRadius.circular(AppTokens.radiusLg),
                          ),
                          child: const Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 16,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
