import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';

/// Prepared image container for future product assets.
/// Does NOT insert placeholder, generated, stock, or internet images.
class AxionImageSlot extends StatelessWidget {
  const AxionImageSlot({
    super.key,
    this.assetPath,
    this.aspectRatio = 1.0,
    this.borderRadius = AppTokens.radiusCard,
  });

  final String? assetPath;
  final double aspectRatio;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: (assetPath != null && assetPath!.isNotEmpty)
            ? Image.asset(
                assetPath!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.expand(),
              )
            : const SizedBox.expand(),
      ),
    );
  }
}
