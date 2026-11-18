import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:a_xion_digital/app.dart';
import 'package:a_xion_digital/core/localization/app_locale.dart';
import 'package:a_xion_digital/state/cart_controller.dart';
import 'package:a_xion_digital/state/favorites_controller.dart';

Future<void> _loadBundledFonts() async {
  final families = {
    'Space Grotesk': [
      'assets/fonts/SpaceGrotesk-Regular.ttf',
      'assets/fonts/SpaceGrotesk-Medium.ttf',
      'assets/fonts/SpaceGrotesk-SemiBold.ttf',
      'assets/fonts/SpaceGrotesk-Bold.ttf',
    ],
    'Plus Jakarta Sans': [
      'assets/fonts/PlusJakartaSans-Regular.ttf',
      'assets/fonts/PlusJakartaSans-Medium.ttf',
      'assets/fonts/PlusJakartaSans-SemiBold.ttf',
      'assets/fonts/PlusJakartaSans-Bold.ttf',
    ],
    'Noto Kufi Arabic': [
      'assets/fonts/NotoKufiArabic-Regular.ttf',
      'assets/fonts/NotoKufiArabic-Medium.ttf',
      'assets/fonts/NotoKufiArabic-SemiBold.ttf',
      'assets/fonts/NotoKufiArabic-Bold.ttf',
    ],
  };

  for (final entry in families.entries) {
    final loader = FontLoader(entry.key);
    for (final path in entry.value) {
      loader.addFont(rootBundle.load(path));
    }
    await loader.load();
  }
}

void main() {
  testWidgets('Capture Flutter screenshots at 1440x900, 768x1024, 390x844',
      (WidgetTester tester) async {
    await _loadBundledFonts();
    SharedPreferences.setMockInitialValues({});
    final localeController = LocaleController();
    final cartController = CartController();
    final favoritesController = FavoritesController();

    final viewports = {
      'desktop_1440x900': const Size(1440, 900),
      'tablet_768x1024': const Size(768, 1024),
      'mobile_390x844': const Size(390, 844),
    };

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    for (final entry in viewports.entries) {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = entry.value;

      await tester.pumpWidget(
        AxionDigitalApp(
          key: ValueKey(entry.key),
          localeController: localeController,
          cartController: cartController,
          favoritesController: favoritesController,
        ),
      );
      await tester.pump();
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 80));
      });
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 500));

      await expectLater(
        find.byType(AxionDigitalApp),
        matchesGoldenFile('goldens/${entry.key}.png'),
      );
    }
  });
}
