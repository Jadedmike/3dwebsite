import 'package:flutter/material.dart';
import '../../core/config/app_config.dart';

/// Renders the official A-Xion Digital logo from `assets/images/logo.png`,
/// preserving its original proportions (3:1) and colors.
/// Never recreates the logo as text or replaces it with an icon.
class AxionLogo extends StatelessWidget {
  const AxionLogo({
    super.key,
    this.height = 34.0,
    this.onTap,
  });

  final double height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      AppConfig.logoAssetPath,
      height: height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) {
        // Reserve exact 3:1 logo footprint until assets/images/logo.png is uploaded.
        return SizedBox(
          height: height,
          width: height * 3.0,
        );
      },
    );

    if (onTap == null) return image;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: image,
      ),
    );
  }
}
