import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  static const String _localeKey = 'app_locale';
  static const List<String> _supportedLanguages = ['tr', 'en', 'es', 'pt', 'fr', 'it', 'de', 'ru', 'ja', 'ko', 'hi'];

  LocaleNotifier() : super(const Locale('tr')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedLocale = prefs.getString(_localeKey);
    
    if (savedLocale == null) {
      // Check device locale
      final deviceLocale = PlatformDispatcher.instance.locale.languageCode;
      savedLocale = _supportedLanguages.contains(deviceLocale) ? deviceLocale : 'tr';
    }
    
    state = Locale(savedLocale);
  }

  Future<void> setLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, languageCode);
    state = Locale(languageCode);
  }
}
