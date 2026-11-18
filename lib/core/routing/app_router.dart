import 'package:go_router/go_router.dart';
import '../../core/localization/app_locale.dart';
import '../../core/localization/app_strings.dart';
import '../../data/models/product.dart';
import '../../features/cart/cart_page.dart';
import '../../features/catalog/catalog_page.dart';
import '../../features/favorites/favorites_page.dart';
import '../../features/home/home_page.dart';
import '../../features/product_details/product_details_page.dart';
import '../../shared/widgets/axion_shell.dart';
import '../../state/cart_controller.dart';
import '../../state/favorites_controller.dart';

GoRouter createAppRouter({
  required LocaleController localeController,
  required CartController cartController,
  required FavoritesController favoritesController,
  List<Product> products = const [],
}) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AxionShell(
          localeController: localeController,
          cartController: cartController,
          favoritesController: favoritesController,
          body: child,
        ),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => HomePage(
              localeController: localeController,
              cartController: cartController,
              favoritesController: favoritesController,
              products: products,
            ),
          ),
          GoRoute(
            path: '/products',
            builder: (context, state) => CatalogPage(
              localeController: localeController,
              cartController: cartController,
              favoritesController: favoritesController,
              products: products,
              searchQuery: state.uri.queryParameters['q'] ?? '',
            ),
          ),
          GoRoute(
            path: '/category/:slug',
            builder: (context, state) {
              final cat =
                  StoreCategory.fromSlug(state.pathParameters['slug']) ??
                      StoreCategory.figuresAnime;
              return CatalogPage(
                localeController: localeController,
                cartController: cartController,
                favoritesController: favoritesController,
                products: products,
                activeCategory: cat,
              );
            },
          ),
          GoRoute(
            path: '/product/:id',
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              Product? match;
              for (final p in products) {
                if (p.id == id) {
                  match = p;
                  break;
                }
              }
              return ProductDetailsPage(
                localeController: localeController,
                cartController: cartController,
                favoritesController: favoritesController,
                productId: id,
                product: match,
              );
            },
          ),
          GoRoute(
            path: '/cart',
            builder: (context, state) => CartPage(
              localeController: localeController,
              cartController: cartController,
              products: products,
            ),
          ),
          GoRoute(
            path: '/favorites',
            builder: (context, state) => FavoritesPage(
              localeController: localeController,
              cartController: cartController,
              favoritesController: favoritesController,
              products: products,
            ),
          ),
        ],
      ),
    ],
  );
}
