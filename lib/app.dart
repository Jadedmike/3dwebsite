import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'core/config/app_config.dart';
import 'core/localization/app_locale.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/models/product.dart';
import 'state/cart_controller.dart';
import 'state/favorites_controller.dart';

class AxionDigitalApp extends StatefulWidget {
  const AxionDigitalApp({
    super.key,
    required this.localeController,
    required this.cartController,
    required this.favoritesController,
    this.products = const [],
  });

  final LocaleController localeController;
  final CartController cartController;
  final FavoritesController favoritesController;
  final List<Product> products;

  @override
  State<AxionDigitalApp> createState() => _AxionDigitalAppState();
}

class _AxionDigitalAppState extends State<AxionDigitalApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createAppRouter(
      localeController: widget.localeController,
      cartController: widget.cartController,
      favoritesController: widget.favoritesController,
      products: widget.products,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.localeController,
      builder: (context, _) {
        final isArabic = widget.localeController.isArabic;
        return MaterialApp.router(
          title: AppConfig.brandName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.build(isArabic: isArabic),
          locale: widget.localeController.locale,
          supportedLocales: const [
            Locale('ar'),
            Locale('tr'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            return Directionality(
              textDirection: widget.localeController.textDirection,
              child: child ?? const SizedBox.shrink(),
            );
          },
          routerConfig: _router,
        );
      },
    );
  }
}
