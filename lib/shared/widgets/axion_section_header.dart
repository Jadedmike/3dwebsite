import 'package:flutter/material.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/app_typography.dart';

/// Consistent editorial section header matching Stitch c5f4ae8c4c5043b2aa1fbb78e4105b85.
class AxionSectionHeader extends StatelessWidget {
  const AxionSectionHeader({
    super.key,
    required this.isArabic,
    required this.title,
    this.badge,
    this.subtitle,
    this.actionLabel,
    this.onActionTap,
  });

  final bool isArabic;
  final String title;
  final String? badge;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);

    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (badge != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.purpleLight,
              borderRadius: BorderRadius.circular(AppTokens.radiusPill),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Text(
              badge!,
              style: AppTypography.headlineStyle(
                isArabic: isArabic,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.purple,
                letterSpacing: 0.6,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
        Text(
          title,
          style: AppTypography.headlineStyle(
            isArabic: isArabic,
            fontSize: isMobile ? 24 : 30,
            fontWeight: FontWeight.w700,
            color: AppColors.charcoal,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: AppTypography.bodyStyle(
              isArabic: isArabic,
              fontSize: 14,
              color: AppColors.charcoalMuted,
            ),
          ),
        ],
      ],
    );

    if (actionLabel == null || onActionTap == null) {
      return titleBlock;
    }

    final actionWidget = InkWell(
      onTap: onActionTap,
      borderRadius: BorderRadius.circular(AppTokens.radiusPill),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              actionLabel!,
              style: AppTypography.headlineStyle(
                isArabic: isArabic,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.purple,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              isArabic ? Icons.arrow_back_rounded : Icons.arrow_forward_rounded,
              size: 16,
              color: AppColors.purple,
            ),
          ],
        ),
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleBlock,
          const SizedBox(height: 12),
          actionWidget,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: titleBlock),
        const SizedBox(width: 16),
        actionWidget,
      ],
    );
  }
}
