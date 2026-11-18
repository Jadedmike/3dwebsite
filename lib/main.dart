import 'package:flutter/material.dart';
import 'app.dart';
import 'core/localization/app_locale.dart';
import 'data/repositories/product_repository.dart';
import 'state/cart_controller.dart';
import 'state/favorites_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final localeController = LocaleController();
  final cartController = CartController();
  final favoritesController = FavoritesController();
  const productRepository = AssetProductRepository();

  final results = await Future.wait([
    localeController.load(),
    cartController.load(),
    favoritesController.load(),
    productRepository.loadProducts(),
  ]);

  final products = results[3] as List<dynamic>;

  runApp(
    AxionDigitalApp(
      localeController: localeController,
      cartController: cartController,
      favoritesController: favoritesController,
      products: products.cast(),
    ),
  );
}
