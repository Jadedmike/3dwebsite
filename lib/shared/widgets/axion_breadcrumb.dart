import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class BreadcrumbSegment {
  const BreadcrumbSegment({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;
}

/// Consistent breadcrumb trail mirroring automatically in RTL/LTR.
class AxionBreadcrumb extends StatelessWidget {
  const AxionBreadcrumb({
    super.key,
    required this.isArabic,
    required this.segments,
  });

  final bool isArabic;
  final List<BreadcrumbSegment> segments;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      runSpacing: 4,
      children: [
        for (int i = 0; i < segments.length; i++) ...[
          if (i > 0)
            Icon(
              isArabic
                  ? Icons.chevron_left_rounded
                  : Icons.chevron_right_rounded,
              size: 16,
              color: AppColors.charcoalMuted,
            ),
          if (segments[i].onTap != null && i < segments.length - 1)
            InkWell(
              onTap: segments[i].onTap,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: Text(
                  segments[i].label,
                  style: AppTypography.bodyStyle(
                    isArabic: isArabic,
                    fontSize: 12.5,
                    color: AppColors.charcoalMuted,
                  ),
                ),
              ),
            )
          else
            Text(
              segments[i].label,
              style: AppTypography.bodyStyle(
                isArabic: isArabic,
                fontSize: 12.5,
                fontWeight: i == segments.length - 1
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: i == segments.length - 1
                    ? AppColors.purple
                    : AppColors.charcoalMuted,
              ),
            ),
        ],
      ],
    );
  }
}
