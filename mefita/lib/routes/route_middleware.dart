import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mefita/services/global_controller.dart';
import 'package:mefita/services/helpers/storage_service.dart';
import 'app_routes.dart';

class RouteMiddleware extends GetMiddleware {
  // final storage = const FlutterSecureStorage();
  final storageService = StorageService.instance;
  bool _isInitialized = false;
  bool _isCheckingAuth = false;

  @override
  RouteSettings? redirect(String? route) {
    // Don't redirect if we're already on the splash screen
    if (route == AppRoutes.splash) {
      return null;
    }

    // Check if we've already initialized
    if (!_isInitialized) {
      _isInitialized = true;
      return null;
    }

    // Prevent multiple simultaneous auth checks
    if (_isCheckingAuth) {
      return null;
    }

    _isCheckingAuth = true;
    _checkAuth(route).then((redirectRoute) {
      _isCheckingAuth = false;
      if (redirectRoute != null && redirectRoute.name != route) {
        Get.offNamed(redirectRoute.name!);
      }
    });

    return null;
  }

  Future<RouteSettings?> _checkAuth(String? route) async {
    // Get the current route
    final currentRoute = Get.currentRoute;

    // Don't redirect if we're already on the target route
    if (currentRoute == route) {
      return null;
    }

    // Check if user is logged in
    final token = await storageService.getAccessToken();
    if (token == null) {
      // If not logged in and not already on login screen
      if (route != AppRoutes.login) {
        return RouteSettings(name: AppRoutes.login);
      }
      return null;
    }

    // Get user data from AuthController
    final user = await storageService.getUserProfile();
    if (user == null) {
      // If no user data, redirect to login
      if (route != AppRoutes.login) {
        return RouteSettings(name: AppRoutes.login);
      }
      return null;
    }

    // If logged in and trying to access auth screens or onboarding, redirect to home
    if (route == AppRoutes.login || route == AppRoutes.intro) {
      return RouteSettings(name: AppRoutes.main);
    }

    return null;
  }

  Future<void> checkAuthStatus() async {
    final currentRoute = Get.currentRoute;
    final redirectRoute = await _checkAuth(currentRoute);

    if (redirectRoute != null && redirectRoute.name != currentRoute) {
      Get.offNamed(redirectRoute.name!);
    }
  }
}