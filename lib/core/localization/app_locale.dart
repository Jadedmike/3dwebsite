import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage { ar, tr }

/// Manages active language (Arabic RTL / Turkish LTR) with local persistence.
class LocaleController extends ChangeNotifier {
  static const String _prefKey = 'axion_language';

  AppLanguage _language = AppLanguage.ar;

  AppLanguage get language => _language;
  bool get isArabic => _language == AppLanguage.ar;
  bool get isTurkish => _language == AppLanguage.tr;

  Locale get locale => Locale(_language.name);
  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey);
    if (saved == 'tr') {
      _language = AppLanguage.tr;
    } else {
      _language = AppLanguage.ar;
    }
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage lang) async {
    if (_language == lang) return;
    _language = lang;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, lang.name);
  }

  Future<void> toggle() =>
      setLanguage(isArabic ? AppLanguage.tr : AppLanguage.ar);
}
