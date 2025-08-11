import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mefita/services/global_controller.dart';
import 'package:mefita/services/helpers/network_service.dart';
import 'package:mefita/utils/constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthApiInterface{

// ==============================================================================
// =========================== START SIGNUP ===============================

  Future<RequestResponseData> signup(var data) async {
    // GlobalController globalController = Get.find();
    print("==== Start signup ====");
    NetworkService generalNetworkService = NetworkService(userTokenRequired: false);
    RequestResponseData responseData = await generalNetworkService.postRequest(url: URLs.signup, data: data);
    print("==== End signup ====");
    return responseData;
  }

// ============================ END SIGNUP ===============================
// ==============================================================================


// ==============================================================================
// =========================== START USER LOG IN  ===============================

  Future<RequestResponseData> logUserIn(var data) async {
    print("==== Start log user in ====");
    NetworkService generalNetworkService = NetworkService(userTokenRequired: false);
    RequestResponseData responseData = await generalNetworkService.postRequest(url: URLs.login, data: data);
    print(responseData.data.toString());
    if (responseData.status){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(SharedPrefKey.userIsLoggedIn, true);
      GlobalController globalController = Get.find();
      globalController.userIsLoggedIn.value = true;
      globalController.tokenData = responseData.data;
      globalController.tokenData["expiry_time"] = DateTime.now().millisecondsSinceEpoch + globalController.tokenData["expires_in"];
      await prefs.setString(SharedPrefKey.tokenData, jsonEncode(globalController.tokenData));
      // await globalController.getLoggedInUserData();
      print("==== User login success ====");
    }else{
      print("==== User login failed ====");
    }

    return responseData;
  }

// ============================ END USER LOG IN  ===============================
// ==============================================================================


// ==============================================================================
// =========================== START COMPLETE USER PROFILE  ===============================

  Future<RequestResponseData> completeUserProfile(var data) async {
    print("==== Start complete user profile ====");
    NetworkService networkService = NetworkService(userTokenRequired: true);
    RequestResponseData responseData = await networkService.patchRequest(url: URLs.completeUserProfile, data: data);
    if (responseData.status){
      await getUserProfile();
      print("==== Complete user profile success ====");
    }else{
      print("==== Complete user profile failed ====");
    }

    return responseData;
  }

// ============================ END COMPLETE USER PROFILE  ===============================
// ==============================================================================


// ==============================================================================
// =========================== START SEND PASSWORD RESET LINK  ===============================

  Future<RequestResponseData> sendPasswordResetEmail(var data) async {
    print("==== Start send password reset email ====");
    NetworkService networkService = NetworkService(userTokenRequired: true);
    RequestResponseData responseData = await networkService.postRequest(url: URLs.sendPasswordResetEmail, data: data);
    if (responseData.status){
      print("==== Complete send password reset email success ====");
    }else{
      print("==== Complete send password reset email failed ====");
    }

    return responseData;
  }

// ============================ END SEND PASSWORD RESET LINK  ===============================
// ==============================================================================


// ==============================================================================
// =========================== START GET USER PROFILE  ===============================

  Future<RequestResponseData> getUserProfile() async {
    NetworkService networkService = NetworkService(userTokenRequired: true);
    GlobalController globalController = Get.find();
    print("==== Start get user profile ====");
    RequestResponseData responseData = await networkService.getRequest(url: URLs.getUserProfile);
    // log(responseData.data.toString());
    if (responseData.status){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // globalController.userProfile.value = responseData.data;
      globalController.userProfile.value = Map<String, dynamic>.from(responseData.data);
      prefs.setString(SharedPrefKey.userProfile, jsonEncode(responseData.data));

      print("==== User profile fetched ====");
    }else{
      print("==== Get user profile failed ====");
    }

    return responseData;
  }

// ============================ END GET USER PROFILE  ===============================
// ==============================================================================


// ==============================================================================
// =========================== START SEND OTP  ===============================

  // Future<RequestResponseData> sendOtp(String phone) async {
  //   print("==== Start send otp ====");
  //   NetworkService networkService = NetworkService(userTokenRequired: true);
  //   RequestResponseData responseData = await networkService.postRequest(url: URLs.sendOtp, data: {"phone": phone});
  //   print("==== End send otp ====");
  //   return responseData;
  // }

// ============================ END SEND OTP  ===============================
// ==============================================================================


// ==============================================================================
// =========================== START VERIFY OTP  ===============================

  // Future<RequestResponseData> verifyOtp(String verificationId, String code) async {
  //   print("==== Start verify otp ====");
  //   NetworkService networkService = NetworkService(userTokenRequired: true);
  //   RequestResponseData responseData = await networkService.postRequest(url: URLs.verifyOtp, data: {
  //     "verificationId": verificationId,
  //     "code": code
  //   });
  //   print("==== End verify otp ====");
  //   return responseData;
  // }

// ============================ END VERIFY OTP  ===============================
// ==============================================================================


// ==============================================================================
// =========================== START SET PIN  ===============================

  Future<RequestResponseData> setPin(String pin) async {
    print("==== Start set pin ====");
    NetworkService networkService = NetworkService(userTokenRequired: true);
    RequestResponseData responseData = await networkService.postRequest(url: URLs.setPin, data: {"pin": pin});
    if (responseData.status){
      await getUserProfile();
      print("==== PIN set success ====");
    }else{
      print("==== PIN set failed ====");
    }
    print("==== End set pin ====");
    return responseData;
  }

// ============================ END SET PIN  ===============================
// ==============================================================================


// ==============================================================================
// =========================== START CHANGE PIN  ===============================

  Future<RequestResponseData> changePin(data) async {
    print("==== Start change pin ====");
    NetworkService networkService = NetworkService(userTokenRequired: true);
    RequestResponseData responseData = await networkService.postRequest(url: URLs.changePin, data: data);
    if (responseData.status){
      print("==== PIN change success ====");
    }else{
      print("==== PIN change failed ====");
    }
    print("==== End change pin ====");
    return responseData;
  }

// ============================ END CHANGE PIN  ===============================
// ==============================================================================


// ==============================================================================
// =========================== START VERIFY PIN  ===============================

  Future<RequestResponseData> verifyPin(String pin) async {
    print("==== Start verify pin ====");
    NetworkService networkService = NetworkService(userTokenRequired: true);
    RequestResponseData responseData = await networkService.postRequest(url: URLs.verifyPin, data: {"pin": pin});
    print("==== End verify pin ====");
    return responseData;
  }

// ============================ END VERIFY PIN  ===============================
// ==============================================================================

// ==============================================================================
// =========================== START CHANGE PASSWORD  ===============================

  Future<RequestResponseData> changePassword(var data) async {
    print("==== Start change password ====");
    NetworkService networkService = NetworkService(userTokenRequired: true);
    RequestResponseData responseData = await networkService.patchRequest(url: URLs.changePassword, data: data);
    if (responseData.status){
      print("==== Password change success ====");
    }else{
      print("==== Password change failed ====");
    }
    print("==== End change password ====");
    return responseData;
  }

// ============================ END CHANGE PASSWORD  ===============================
// ==============================================================================

// ==============================================================================
// =========================== START UPDATE PROFILE  ===============================

  Future<RequestResponseData> updateProfile(var data) async {
    print("==== Start update profile ====");
    NetworkService networkService = NetworkService(userTokenRequired: true);
    RequestResponseData responseData = await networkService.patchRequest(url: URLs.updateProfile, data: data);
    if (responseData.status){
      await getUserProfile();
      print("==== Update profile success ====");
    }else{
      print("==== Update profile failed ====");
    }
    print("==== End update profile ====");
    return responseData;
  }

// ============================ END UPDATE PROFILE  ===============================
// ==============================================================================

// ==============================================================================
// =========================== START DELETE ACCOUNT  ===============================

  Future<RequestResponseData> deleteAccount() async {
    print("==== Start delete account ====");
    NetworkService networkService = NetworkService(userTokenRequired: true);
    RequestResponseData responseData = await networkService.deleteRequest(url: URLs.deleteAccount);
    print("==== End delete account ====");
    return responseData;
  }

// ============================ END DELETE ACCOUNT  ===============================
// ==============================================================================

// ==============================================================================
// =========================== START UPDATE NOTIFICATION TOKEN  ===============================

  /*Future<RequestResponseData> setNotificationToken() async {
    GlobalController globalController = Get.find();
    print("==== Start update notification token ====");
    String? token = await FirebaseMessaging.instance.getToken();
    await FirebaseMessaging.instance.subscribeToTopic(globalController.userProfile.value["id"]);
    var data = {
      "notification_token": token
    };
    print("==== Notification Token: $token ===");
    NetworkService networkService = NetworkService(userTokenRequired: true);
    RequestResponseData responseData = await networkService.postRequest(url: URLs.updateNotificationToken, data: data);
    print("==== End update notification token ====");
    return responseData;
  }*/

  Future<RequestResponseData> setNotificationToken() async {
    GlobalController globalController = Get.find();
    print("==== Start update notification token ====");

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // 2. iOS-specific: Ensure APNs token is available
    if (Platform.isIOS) {
      String? apnsToken = await messaging.getAPNSToken();
      print("==== APNs Token: $apnsToken ====");
    }

    // 3. Get FCM token
    String? token = await messaging.getToken();
    print("==== FCM Notification Token: $token ====");

    // 4. Subscribe to topic (e.g., user ID)
    await messaging.subscribeToTopic(globalController.userProfile.value["id"]);

    // 5. Send token to backend
    var data = {
      "notification_token": token
    };

    NetworkService networkService = NetworkService(userTokenRequired: true);
    RequestResponseData responseData = await networkService.postRequest(
      url: URLs.updateNotificationToken,
      data: data,
    );

    print("==== End update notification token ====");
    return responseData;
  }

// ============================ END UPDATE NOTIFICATION TOKEN  ===============================
// ==============================================================================

}
