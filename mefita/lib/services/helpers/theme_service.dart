import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class ThemeService extends GetxService {
  static ThemeService get to => Get.find();

  final _isDarkMode = false.obs;
  final _useSystemTheme = true.obs;

  bool get isDarkMode => _isDarkMode.value;
  bool get useSystemTheme => _useSystemTheme.value;

  Future<ThemeService> init() async {
    await _loadThemeMode();
    return this;
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final darkMode = prefs.getBool('dark_mode');
    final systemTheme = prefs.getBool('use_system_theme');

    _isDarkMode.value = darkMode ?? false;
    _useSystemTheme.value = systemTheme ?? true;

    if (_useSystemTheme.value) {
      final brightness = WidgetsBinding.instance.window.platformBrightness;
      _isDarkMode.value = brightness == Brightness.dark;
    }
  }

  Future<void> setThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode.value = isDark;
    _useSystemTheme.value = false;
    await prefs.setBool('dark_mode', isDark);
    await prefs.setBool('use_system_theme', false);
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleTheme() async {
    await setThemeMode(!_isDarkMode.value);
  }

  Future<void> setUseSystemTheme(bool useSystem) async {
    final prefs = await SharedPreferences.getInstance();
    _useSystemTheme.value = useSystem;
    await prefs.setBool('use_system_theme', useSystem);

    if (useSystem) {
      final brightness = WidgetsBinding.instance.window.platformBrightness;
      _isDarkMode.value = brightness == Brightness.dark;
      Get.changeThemeMode(ThemeMode.system);
    } else {
      Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    }
  }
}