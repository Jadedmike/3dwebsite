import 'package:url_launcher/url_launcher.dart';
import '../core/config/app_config.dart';
import '../data/models/product.dart';
import '../state/cart_controller.dart';

/// WhatsApp direct inquiry and checkout helper targeting +905358415766.
abstract final class WhatsAppService {
  static Uri buildChatUri({String? message}) {
    final base = 'https://wa.me/${AppConfig.whatsappDigits}';
    if (message == null || message.trim().isEmpty) {
      return Uri.parse(base);
    }
    return Uri.parse('$base?text=${Uri.encodeComponent(message)}');
  }

  static Future<bool> openDirectInquiry({required bool isArabic}) async {
    final msg = isArabic
        ? 'مرحباً، أود الاستفسار عن منتجات A-Xion Digital.'
        : 'Merhaba, A-Xion Digital koleksiyonundan bilgi ve sipariş almak istiyorum.';
    return launchUrl(
      buildChatUri(message: msg),
      mode: LaunchMode.externalApplication,
    );
  }

  static Future<bool> openProductInquiry({
    required Product product,
    required bool isArabic,
    int quantity = 1,
  }) async {
    final name = product.localizedName(isArabic: isArabic);
    final msg = isArabic
        ? 'مرحباً، أود الاستفسار وطلب المنتج:\n- $name (${product.id})\n- الخامة: ${product.material}\n- الكمية: $quantity'
        : 'Merhaba, aşağıdaki ürün hakkında bilgi ve sipariş almak istiyorum:\n- $name (${product.id})\n- Malzeme: ${product.material}\n- Adet: $quantity';
    return launchUrl(
      buildChatUri(message: msg),
      mode: LaunchMode.externalApplication,
    );
  }

  static Future<bool> openCartCheckout({
    required List<CartItem> items,
    required Map<String, Product> productMap,
    required bool isArabic,
  }) async {
    final lines = <String>[
      isArabic
          ? 'مرحباً، أود تأكيد طلبي من A-Xion Digital:'
          : 'Merhaba, A-Xion Digital siparişimi onaylamak istiyorum:',
    ];
    for (final item in items) {
      final product = productMap[item.productId];
      final name =
          product?.localizedName(isArabic: isArabic) ?? item.productId;
      lines.add('- $name (${item.productId}) × ${item.quantity}');
    }
    return launchUrl(
      buildChatUri(message: lines.join('\n')),
      mode: LaunchMode.externalApplication,
    );
  }
}
