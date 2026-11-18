import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistent local favorites list (no auth/login required).
class FavoritesController extends ChangeNotifier {
  static const String _prefKey = 'axion_favorite_ids';

  final Set<String> _ids = {};

  Set<String> get ids => Set.unmodifiable(_ids);
  int get count => _ids.length;
  bool isFavorite(String productId) => _ids.contains(productId);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_prefKey);
    if (saved != null) {
      _ids
        ..clear()
        ..addAll(saved);
      notifyListeners();
    }
  }

  Future<void> toggle(String productId) async {
    if (_ids.contains(productId)) {
      _ids.remove(productId);
    } else {
      _ids.add(productId);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefKey, _ids.toList());
  }
}
