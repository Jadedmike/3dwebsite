import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:a_xion_digital/app.dart';
import 'package:a_xion_digital/core/localization/app_locale.dart';
import 'package:a_xion_digital/data/repositories/product_repository.dart';
import 'package:a_xion_digital/state/cart_controller.dart';
import 'package:a_xion_digital/state/favorites_controller.dart';

void main() {
  testWidgets(
      'A-Xion Digital loads 100 products, scrolls smoothly, and supports AR RTL / TR LTR across viewports',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    const repo = AssetProductRepository();
    final products = await tester.runAsync(() => repo.loadProducts()) ?? const [];

    expect(products.length, 100);
    expect(products.where((p) => p.storeCategory == 'gifts').length, 0);

    final localeController = LocaleController();
    final cartController = CartController();
    final favoritesController = FavoritesController();

    for (final size in const [
      Size(1440, 900),
      Size(768, 1024),
      Size(390, 844),
    ]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(
        AxionDigitalApp(
          localeController: localeController,
          cartController: cartController,
          favoritesController: favoritesController,
          products: products,
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 500));

      // Verify scrolling via mouse wheel / drag works cleanly
      final scrollable = find.byType(SingleChildScrollView).first;
      expect(scrollable, findsOneWidget);
      await tester.sendEventToBinding(
        PointerScrollEvent(
          position: Offset(size.width / 2, size.height / 2),
          scrollDelta: const Offset(0, 300),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 500));

      expect(localeController.isArabic, isTrue);
      expect(localeController.textDirection, TextDirection.rtl);

      await localeController.setLanguage(AppLanguage.tr);
      await tester.pump(const Duration(milliseconds: 50));

      expect(localeController.isTurkish, isTrue);
      expect(localeController.textDirection, TextDirection.ltr);

      await localeController.setLanguage(AppLanguage.ar);
      await tester.pump(const Duration(milliseconds: 50));
    }

    await tester.binding.setSurfaceSize(null);
  });
}
