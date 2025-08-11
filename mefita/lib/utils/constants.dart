import 'package:mefita/services/global_controller.dart';
import 'package:get/get.dart';

class URLs{
  static String baseUrl = 'https://joesiskmvg6puja5c3ow6a4rgi.srv.us';
  // static String baseUrl = Get.find<GlobalController>().appSetup.value['base_url'] ?? "";

  static String login = '/auth/mobile-login';
  // static String login = Get.find<GlobalController>().appSetup.value['login'] ?? "";

  static String getUserProfile = '/auth/mobile/me';
  // static String getUserProfile = Get.find<GlobalController>().appSetup.value['get_user_profile'] ?? "";

  static String refreshUserToken = "/auth/refresh-token";
  // static String refreshUserToken = Get.find<GlobalController>().appSetup.value['refresh_token'] ?? "";

  static String getMyAssets = "/api/mobile/assets/my-assets";
  // static String getMyAssets = Get.find<GlobalController>().appSetup.value['get_my_assets'] ?? "";

  static String getMyFuelRequests = "/api/mobile/fuel-requests/my-requests";
  // static String getMyFuelRequests = Get.find<GlobalController>().appSetup.value['get_my_fuel_requests'] ?? "";

  static String submitFuelRequest = "/api/mobile/fuel-requests";
  // static String submitFuelRequest = Get.find<GlobalController>().appSetup.value['submit_fuel_request'] ?? "";

  static String cancelFuelRequest = "/api/mobile/fuel-requests/cancel";
  // static String cancelFuelRequest = Get.find<GlobalController>().appSetup.value['submit_fuel_request'] ?? "";

  static String getNearbyFuelStations = "/api/mobile/nearby-fuel-stations";
  // static String getNearbyFuelStations = Get.find<GlobalController>().appSetup.value['get_nearby_fuel_stations'] ?? "";

  static String updateNotificationToken = "/auth/set-notification-token";
  // static String updateNotificationToken = Get.find<GlobalController>().appSetup.value['set_notification_token'] ?? "";

  static String setPin = "/auth/set-pin";
  // static String setPin = Get.find<GlobalController>().appSetup.value['set_pin'] ?? "";

  static String changePin = "/auth/change-pin";
  // static String changePin = Get.find<GlobalController>().appSetup.value['change_pin'] ?? "";

  static String verifyPin = "/auth/verify-pin";
  // static String verifyPin = Get.find<GlobalController>().appSetup.value['verify_pin'] ?? "";

  static String startTrip = "/api/mobile/trips/";
  // static String startTrip = Get.find<GlobalController>().appSetup.value['start_trip'] ?? "";

  static String endTrip = "/api/mobile/trips/end";
  // static String endTrip = Get.find<GlobalController>().appSetup.value['end_trip'] ?? "";

  static String getMyTrips = "/api/mobile/trips/my-trips";
  // static String getMyTrips = Get.find<GlobalController>().appSetup.value['get_my_trips'] ?? "";

  static String getCouponByCode = "/api/mobile/fuel-requests/coupon/by-code";
  // static String getCouponByCode = Get.find<GlobalController>().appSetup.value['get_coupon_by_code'] ?? "";

  static String authorizeCouponRedemptionWithDriverCode = "/api/mobile/fuel-requests/coupon/authorize-redemption";
  // static String authorizeCouponRedemptionWithDriverCode = Get.find<GlobalController>().appSetup.value['authorize_coupon_redemption_with_driver_code'] ?? "";

  static String getMyCouponRedemptions = "/api/mobile/fuel-requests/coupon/my-redemptions";
  // static String getMyCouponRedemptions = Get.find<GlobalController>().appSetup.value['get_my_coupon_redemptions'] ?? "";

  static String completeFuelRedemption = "/api/mobile/fuel-requests/coupon/redeem";
  // static String completeFuelRedemption = Get.find<GlobalController>().appSetup.value['complete_fuel_redemption'] ?? "";



  static String completeUserProfile = Get.find<GlobalController>().appSetup.value['complete_user_profile'] ?? "";
  static String deleteAccount = Get.find<GlobalController>().appSetup.value['delete_account'] ?? "";
  static String updateProfile = Get.find<GlobalController>().appSetup.value['update_profile'] ?? "";
  static String changePassword = Get.find<GlobalController>().appSetup.value['change_password'] ?? "";
  static String sendPasswordResetEmail = Get.find<GlobalController>().appSetup.value['send_password_reset_email'] ?? "";
  static String signup = Get.find<GlobalController>().appSetup.value['signup'] ?? "";
}

class SharedPrefKey{
  static String seenIntroScreen = 'seenIntroScreen';
  static String appSetup = 'appSetup';
  static String tokenData = 'tokenData';
  static String userIsLoggedIn = 'userIsLoggedIn';
  static String userProfile = 'userProfile';

  static String appInActivityTimestamp = 'appInActivityTimestamp';

  static String myAssets = 'myAssets';
  static String fuelRequestHistory = 'fuelRequestHistory';
  static String tripHistory = 'tripHistory';
  static String couponRedemptions = 'couponRedemptions';
}

class DatabaseRef{
  static String appSetup = 'app_setup';
}

class RequestStatus{
  static int False = 0;
  static int True = 1;
  static int Exist = 2;
  static int NoInternet = 3;
}

class RequestResponseData {
  bool status;
  dynamic data;
  bool connectionAvailable;
  String? message;

  RequestResponseData({
    required this.status,
    this.data,
    required this.connectionAvailable,
    this.message,
  });

}

class OtherConstants{

}

class UserType{
  static String vehicleOwner = 'vehicle_owner';
  static String towingOperator = 'towing_operator';
  static String serviceProvider = 'service_provider';
}

