import 'dart:convert';
import 'package:flutter/services.dart';
import '../../core/config/app_config.dart';
import '../models/product.dart';

abstract interface class ProductRepository {
  Future<List<Product>> loadProducts();
}

/// Loads products from the future `assets/data/products.json` asset.
/// Returns an empty list cleanly until the real dataset is supplied.
class AssetProductRepository implements ProductRepository {
  const AssetProductRepository({
    this.assetPath = AppConfig.productsJsonAssetPath,
  });

  final String assetPath;

  @override
  Future<List<Product>> loadProducts() async {
    try {
      final raw = await rootBundle.loadString(assetPath);
      if (raw.trim().isEmpty) return const [];
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(Product.fromJson)
            .toList(growable: false);
      }
      if (decoded is Map<String, dynamic> && decoded['products'] is List) {
        return (decoded['products'] as List)
            .whereType<Map<String, dynamic>>()
            .map(Product.fromJson)
            .toList(growable: false);
      }
      return const [];
    } catch (_) {
      return const [];
    }
  }
}
