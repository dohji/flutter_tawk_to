import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TranslationService extends GetxService {
  static TranslationService get to => Get.find();
  final _storage = const FlutterSecureStorage();
  final _currentLocale = const Locale('en').obs;

  Locale get currentLocale => _currentLocale.value;

  Future<TranslationService> init() async {
    await _loadSavedLocale();
    return this;
  }

  Future<void> _loadSavedLocale() async {
    final savedLocale = await _storage.read(key: 'app_locale');
    if (savedLocale != null) {
      _currentLocale.value = Locale(savedLocale);
      Get.updateLocale(_currentLocale.value);
    }
  }

  Future<void> changeLocale(String languageCode) async {
    final locale = Locale(languageCode);
    _currentLocale.value = locale;
    await _storage.write(key: 'app_locale', value: languageCode);
    Get.updateLocale(locale);
  }

  String translate(String key) {
    return key.tr;
  }
} 