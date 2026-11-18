import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  const CartItem({
    required this.productId,
    required this.quantity,
    this.selectedColor,
  });

  final String productId;
  final int quantity;
  final String? selectedColor;

  CartItem copyWith({int? quantity, String? selectedColor}) {
    return CartItem(
      productId: productId,
      quantity: quantity ?? this.quantity,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: (json['productId'] ?? '').toString(),
      quantity: (json['quantity'] is int) ? json['quantity'] as int : 1,
      selectedColor: json['selectedColor']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'quantity': quantity,
        if (selectedColor != null) 'selectedColor': selectedColor,
      };
}

/// Persistent local shopping cart (no auth/login required).
class CartController extends ChangeNotifier {
  static const String _prefKey = 'axion_cart_items';

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalCount => _items.fold(0, (sum, item) => sum + item.quantity);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        _items
          ..clear()
          ..addAll(decoded
              .whereType<Map<String, dynamic>>()
              .map(CartItem.fromJson));
        notifyListeners();
      }
    } catch (_) {
      // Ignore malformed stored cart data
    }
  }

  Future<void> addItem(String productId, {String? selectedColor}) async {
    final idx = _items.indexWhere(
      (e) => e.productId == productId && e.selectedColor == selectedColor,
    );
    if (idx >= 0) {
      _items[idx] = _items[idx].copyWith(quantity: _items[idx].quantity + 1);
    } else {
      _items.add(CartItem(
        productId: productId,
        quantity: 1,
        selectedColor: selectedColor,
      ));
    }
    notifyListeners();
    await _save();
  }

  Future<void> updateQuantity(
    String productId,
    int quantity, {
    String? selectedColor,
  }) async {
    final idx = _items.indexWhere(
      (e) => e.productId == productId && e.selectedColor == selectedColor,
    );
    if (idx < 0) return;
    if (quantity <= 0) {
      _items.removeAt(idx);
    } else {
      _items[idx] = _items[idx].copyWith(quantity: quantity);
    }
    notifyListeners();
    await _save();
  }

  Future<void> removeItem(String productId, {String? selectedColor}) async {
    _items.removeWhere(
      (e) => e.productId == productId && e.selectedColor == selectedColor,
    );
    notifyListeners();
    await _save();
  }

  Future<void> clear() async {
    _items.clear();
    notifyListeners();
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefKey,
      jsonEncode(_items.map((e) => e.toJson()).toList()),
    );
  }
}
