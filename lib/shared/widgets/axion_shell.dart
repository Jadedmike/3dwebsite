import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/app_locale.dart';
import '../../core/localization/app_strings.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../services/whatsapp_service.dart';
import '../../state/cart_controller.dart';
import '../../state/favorites_controller.dart';
import 'axion_buttons.dart';
import 'axion_footer.dart';
import 'axion_header.dart';
import 'axion_logo.dart';
import 'axion_mascots.dart';
import 'axion_scroll_reveal.dart';

/// Shared page shell ensuring every route uses the exact same Header, Footer,
/// RTL/LTR directionality, Drawer navigation, and floating WhatsApp FAB.
class AxionShell extends StatefulWidget {
  const AxionShell({
    super.key,
    required this.localeController,
    required this.cartController,
    required this.favoritesController,
    required this.body,
  });

  final LocaleController localeController;
  final CartController cartController;
  final FavoritesController favoritesController;
  final Widget body;

  @override
  State<AxionShell> createState() => _AxionShellState();
}

class _AxionShellState extends State<AxionShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant AxionShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.body != oldWidget.body && _scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        widget.localeController,
        widget.cartController,
        widget.favoritesController,
      ]),
      builder: (context, _) {
        final isArabic = widget.localeController.isArabic;
        final strings = AppStrings(isArabic: isArabic);

        final isDesktop = Breakpoints.isDesktop(context);

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.background,
          drawer: _AxionDrawer(
            isArabic: isArabic,
            strings: strings,
            onNavigate: (route) {
              Navigator.of(context).pop();
              context.go(route);
            },
          ),
          floatingActionButton: AxionFloatingWhatsAppFab(
            tooltip: strings.orderWaHeader,
            onPressed: () =>
                WhatsAppService.openDirectInquiry(isArabic: isArabic),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  AxionHeader(
                    localeController: widget.localeController,
                    favoritesCount: widget.favoritesController.count,
                    cartCount: widget.cartController.totalCount,
                    onHomeTap: () => context.go('/'),
                    onFavoritesTap: () => context.go('/favorites'),
                    onCartTap: () => context.go('/cart'),
                    onWhatsAppTap: () =>
                        WhatsAppService.openDirectInquiry(isArabic: isArabic),
                    onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                    onSearchSubmitted: (q) {
                      final trimmed = q.trim();
                      if (trimmed.isEmpty) {
                        context.go('/products');
                      } else {
                        context.go(
                            '/products?q=${Uri.encodeQueryComponent(trimmed)}');
                      }
                    },
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        AxionScrollScope(
                          controller: _scrollController,
                          child: Scrollbar(
                            controller: _scrollController,
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              physics: const ClampingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  widget.body,
                                  AxionFooter(
                                    localeController: widget.localeController,
                                    onHomeTap: () => context.go('/'),
                                    onAllProductsTap: () =>
                                        context.go('/products'),
                                    onCategoryTap: (cat) =>
                                        context.go('/category/${cat.slug}'),
                                    onWhatsAppTap: () =>
                                        WhatsAppService.openDirectInquiry(
                                      isArabic: isArabic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (!isDesktop)
                          const PositionedDirectional(
                            top: 0,
                            end: 4,
                            child: SpidermanCornerMascot(),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (isDesktop)
                const PositionedDirectional(
                  top: 0,
                  end: 4,
                  child: SpidermanCornerMascot(),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _AxionDrawer extends StatelessWidget {
  const _AxionDrawer({
    required this.isArabic,
    required this.strings,
    required this.onNavigate,
  });

  final bool isArabic;
  final AppStrings strings;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.cardBackground,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: AxionLogo(
                height: 30,
                onTap: () => onNavigate('/'),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: AppColors.border),
            const SizedBox(height: 12),
            _DrawerItem(
              label: strings.homeTitle,
              isArabic: isArabic,
              onTap: () => onNavigate('/'),
            ),
            _DrawerItem(
              label: strings.allProductsTitle,
              isArabic: isArabic,
              onTap: () => onNavigate('/products'),
            ),
            const SizedBox(height: 8),
            for (final cat in StoreCategory.values)
              _DrawerItem(
                label: strings.categoryLabel(cat),
                isArabic: isArabic,
                onTap: () => onNavigate('/category/${cat.slug}'),
              ),
            const SizedBox(height: 8),
            const Divider(color: AppColors.border),
            const SizedBox(height: 8),
            _DrawerItem(
              label: strings.favoritesTitle,
              isArabic: isArabic,
              onTap: () => onNavigate('/favorites'),
            ),
            _DrawerItem(
              label: strings.cartTitle,
              isArabic: isArabic,
              onTap: () => onNavigate('/cart'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.label,
    required this.isArabic,
    required this.onTap,
  });

  final String label;
  final bool isArabic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(
        label,
        style: AppTypography.headlineStyle(
          isArabic: isArabic,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.charcoal,
        ),
      ),
      onTap: onTap,
    );
  }
}
