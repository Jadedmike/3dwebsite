import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_typography.dart';

/// Primary CTA pill button (#6C3D75 background, white label, pill radius).
class AxionPrimaryButton extends StatelessWidget {
  const AxionPrimaryButton({
    super.key,
    required this.label,
    required this.isArabic,
    this.onPressed,
    this.icon,
    this.fullWidth = false,
  });

  final String label;
  final bool isArabic;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.purple,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: const StadiumBorder(),
        ),
        child: Row(
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: AppTypography.headlineStyle(
                isArabic: isArabic,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Secondary inverted charcoal pill button (#2D292B background, white label).
class AxionSecondaryButton extends StatelessWidget {
  const AxionSecondaryButton({
    super.key,
    required this.label,
    required this.isArabic,
    this.onPressed,
    this.icon,
    this.fullWidth = false,
  });

  final String label;
  final bool isArabic;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.charcoal,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: const StadiumBorder(),
        ),
        child: Row(
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: AppTypography.headlineStyle(
                isArabic: isArabic,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Outlined pill button (1.5px border in #2D292B or #6C3D75).
class AxionOutlinedButton extends StatelessWidget {
  const AxionOutlinedButton({
    super.key,
    required this.label,
    required this.isArabic,
    this.onPressed,
    this.borderColor = AppColors.charcoal,
    this.icon,
  });

  final String label;
  final bool isArabic;
  final VoidCallback? onPressed;
  final Color borderColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: borderColor,
        side: BorderSide(color: borderColor, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: AppTypography.headlineStyle(
              isArabic: isArabic,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: borderColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dedicated WhatsApp Direct / Checkout pill button (#25D366 / #34D399).
class AxionWhatsAppButton extends StatelessWidget {
  const AxionWhatsAppButton({
    super.key,
    required this.label,
    required this.isArabic,
    this.onPressed,
    this.backgroundColor = AppColors.whatsappGreen,
    this.fullWidth = false,
  });

  final String label;
  final bool isArabic;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: const StadiumBorder(),
        ),
        child: Row(
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.chat_bubble_outline_rounded, size: 17),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.headlineStyle(
                  isArabic: isArabic,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Persistent floating WhatsApp action button matching Stitch Level 3 elevation.
class AxionFloatingWhatsAppFab extends StatelessWidget {
  const AxionFloatingWhatsAppFab({
    super.key,
    required this.onPressed,
    required this.tooltip,
  });

  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: AppTokens.shadowFloating,
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        tooltip: tooltip,
        backgroundColor: AppColors.whatsappGreen,
        foregroundColor: AppColors.white,
        elevation: 0,
        shape: const CircleBorder(),
        child: const Icon(Icons.chat_rounded, size: 26),
      ),
    );
  }
}
