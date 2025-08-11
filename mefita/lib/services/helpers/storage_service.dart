import 'dart:convert';
import 'package:mefita/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static StorageService? _instance;
  static StorageService get instance => _instance ??= StorageService._();

  StorageService._();

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> saveTokenData({required String data}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPrefKey.tokenData, data);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedData = prefs.getString(SharedPrefKey.tokenData);
    Map<String, dynamic> data = {};
    if(storedData != null){
      data = jsonDecode(storedData);
      return data["access_token"];
    }
    return null;
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedData = prefs.getString(SharedPrefKey.tokenData);
    Map<String, dynamic> data = {};
    if(storedData != null){
      data = jsonDecode(storedData);
      return data["refresh_token"];
    }
    return null;
  }

  Future<void> saveAppSetup({required String data}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPrefKey.appSetup, data);
  }

  Future<dynamic> getAppSetup() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedAppSetup = prefs.getString(SharedPrefKey.appSetup);
    if(storedAppSetup != null){
      return jsonDecode(storedAppSetup);
    }
    return null;
  }

  Future<void> saveUserProfile({required String data}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPrefKey.userProfile, data);
  }

  Future<dynamic> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedData = prefs.getString(SharedPrefKey.userProfile);
    if(storedData != null){
      return jsonDecode(storedData);
    }
    return null;
  }

  Future<void> markSeenIntroScreen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPrefKey.seenIntroScreen, true);
  }

  Future<bool> hasSeenIntroScreen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPrefKey.seenIntroScreen) ?? false;
  }

  Future<void> markUserAsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SharedPrefKey.userIsLoggedIn, true);
  }

  Future<bool> userLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SharedPrefKey.userIsLoggedIn) ?? false;
  }
}