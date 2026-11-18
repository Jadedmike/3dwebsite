import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:a_xion_digital/app.dart';
import 'package:a_xion_digital/core/localization/app_locale.dart';
import 'package:a_xion_digital/data/repositories/product_repository.dart';
import 'package:a_xion_digital/state/cart_controller.dart';
import 'package:a_xion_digital/state/favorites_controller.dart';

void main() {
  testWidgets('A-Xion Digital loads 100 products and keeps Gifts empty',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    const repo = AssetProductRepository();
    final products = await tester.runAsync(() => repo.loadProducts()) ?? const [];

    expect(products.length, 100);
    expect(products.first.id, 'prod-001');
    expect(products.last.id, 'prod-100');
    expect(products.where((p) => p.storeCategory == 'figures-anime').length, 25);
    expect(products.where((p) => p.storeCategory == 'geometric-office').length, 7);
    expect(
      products.where((p) => p.storeCategory == 'home-decor-kitchen').length,
      42,
    );
    expect(products.where((p) => p.storeCategory == 'gifts').length, 0);
    expect(products.where((p) => p.storeCategory == 'keychains').length, 13);
    expect(products.where((p) => p.storeCategory == null).length, 13);
    expect(products.every((p) => p.price == null), isTrue);

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
