import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mefita/routes/app_routes.dart';
import 'package:mefita/services/api/auth_apis.dart';
import 'package:mefita/services/helpers/storage_service.dart';
import 'package:mefita/ui/global/auth/signin/signin.dart';
import 'package:mefita/ui/global/helpers/globals.dart';
import 'package:mefita/utils/constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/general_apis.dart';
import 'helpers/token_service.dart';

class GlobalController extends GetxController{

  Map<String, dynamic> tokenData = {};
  Rx<Map<String, dynamic>> userProfile = Rx<Map<String, dynamic>>({});
  Rx<Map<String, dynamic>> appSetup = Rx<Map<String, dynamic>>({});
  Rx<bool> userIsLoggedIn = Rx(false);

  // Institution driver
  RxList myAssets = RxList([]);
  RxList fuelRequestHistory = RxList([]);
  RxList tripHistory = RxList([]);
  RxList nearbyFuelStations = RxList([]);

  // Pump attendant
  RxList couponRedemptions = RxList([]);
  Rx<Map<String, dynamic>> currentCouponData = Rx<Map<String, dynamic>>({});

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();

  }

  splashScreenTimeout() async{

    await getStoredTokens();
    Timer(const Duration(seconds: 3), () async {
      await getLocalData();

      var seenIntroScreen = await StorageService.instance.hasSeenIntroScreen();
      userIsLoggedIn.value = await StorageService.instance.userIsLoggedIn();

      if(seenIntroScreen == true){
        if(userIsLoggedIn.value){

          TokenService tokenService = TokenService();
          RequestResponseData res = await tokenService.refreshUserToken();
          if (res.status == false){
            logout();
          }else{
            debugPrint("User is logged in, redirecting to main screen");

            redirectUser();

          }

        }else{
          debugPrint("User is not logged in, redirecting to sign in screen");
          Get.offAll(() => const SignInScreen());
        }
      }else{
        debugPrint("User has not seen intro screen, redirecting to onboarding screen");
        // TODO: Implement onboarding screen
        Get.offNamed(AppRoutes.intro);
      }
    });
  }


  Future getAppSetup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedAppSetup = prefs.getString(SharedPrefKey.appSetup);

    final fs = FirebaseFirestore.instanceFor(
      app: Firebase.app(),
      // databaseId: 'main',
    );
    final snapshot = await fs
        .collection("endpoints")
        .get();

    if (snapshot.docs.isNotEmpty) {
      appSetup.value =  snapshot.docs.firstWhere((element) => element.id == 'endpoints').data();
      prefs.setString(SharedPrefKey.appSetup, jsonEncode(appSetup.value));
    }else{
      if(storedAppSetup != null){
        appSetup.value = jsonDecode(storedAppSetup);
      }
    }

  }


  getStoredTokens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      try{
        String? storedData = prefs.getString(SharedPrefKey.tokenData);
        if(storedData != null){
          tokenData = jsonDecode(storedData);
        }
      }catch (e){
        debugPrint("getStoredTokens(): Error getting local data: $e");
      }
  }


  getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userIsLoggedIn.value = prefs.getBool(SharedPrefKey.userIsLoggedIn) ?? false;
    if(userIsLoggedIn.value){
      try{
        // Get user profile
        String? storedUserProfile = prefs.getString(SharedPrefKey.userProfile);
        if(storedUserProfile != null){
          userProfile.value = jsonDecode(storedUserProfile);
        }
      }catch (e){
        debugPrint("Error getting local data: $e");
      }


      // try{
      //   // Get recipients
      //   String? storedRecipients = prefs.getString(SharedPrefKey.recipients);
      //   if(storedRecipients != null){
      //     recipients.clear();
      //     List data = jsonDecode(storedRecipients);
      //     List<Recipient> recipientList = data.map((e) => Recipient.fromJson(e)).toList();
      //     recipients.addAll(recipientList);
      //   }
      // }catch (e){
      //   debugPrint("Error getting local data: $e");
      // }

    }
  }

  redirectUser({bool? hasLoadingIndicator = false}) async {
    AuthApiInterface authApiInterface = AuthApiInterface();
    // await Future.wait([
    // authApiInterface.getUserProfile(),
    // authApiInterface.setNotificationToken()
    // ]);
    await authApiInterface.getUserProfile();
    try{
      await authApiInterface.setNotificationToken();
    }catch (e){
      print("Error setting notification token: $e");
    }
    if(tokenData["user"]["type"] == UserType.vehicleOwner){
      print("Redirecting to Customer Main Screen");
      // await Future.wait([
      //   getAppSettings(),
      //   setNotificationToken(),
      //   getProducts(),
      //   getCustomerOrders(),
      //   getCustomerTransactions(),
      //   getFuelStations(),
      //   fetchBills()
      // ]);
      if (hasLoadingIndicator == true) Globals.hideLoadingDialog();
      // Get.offAll(() => const CustomerMainScreen());
    }else if(tokenData["user"]["type"] == UserType.serviceProvider){
      print("Redirecting to Delivery Agent Main Screen");
      // await Future.wait([
      //   getAppSettings(),
      //   setNotificationToken(),
      //   getProducts(),
      //   getOperatorOrders()
      // ]);
      if (hasLoadingIndicator == true) Globals.hideLoadingDialog();
      // Get.offAll(() => const DriverMainScreen());
    }else if(tokenData["user"]["type"] == UserType.towingOperator){
      print("Redirecting to Pump Attendant Main Screen");
      GeneralApiInterface generalApiInterface = GeneralApiInterface();
      await Future.wait([
        generalApiInterface.getMyCouponRedemptions()
      ]);
      if (hasLoadingIndicator == true) Globals.hideLoadingDialog();
      // Get.offAll(() => const PumpAttendantHomeScreen());
    }else{
      logout();
      if (hasLoadingIndicator == true) Globals.hideLoadingDialog();
      print("Unknown account type: ${tokenData["user"]["role"]}");
      Globals.errorDialog(
        title: 'Error',
        content: Text('Unknown account type. Kindly contact support',
          textAlign: TextAlign.center,
          style: TextStyle(color: Get.theme.colorScheme.onBackground),
        ),
        image: const Icon(Icons.error, size: 40, color: Colors.red),
        okayTap: (){
          Get.back();
        },
      );
    }
  }

  getLoggedInUserData() async {
    AuthApiInterface authApiInterface = AuthApiInterface();
    await authApiInterface.getUserProfile();
    if(tokenData["user"]["type"] == UserType.vehicleOwner){
      // await Future.wait([
      //   getAppSettings(),
      //   setNotificationToken(),
      //   getProducts(),
      //   getCustomerOrders(),
      //   getCustomerTransactions(),
      //   getFuelStations(),
      //   fetchBills()
      // ]);

      GeneralApiInterface generalApiInterface = GeneralApiInterface();
      await Future.wait([
        generalApiInterface.getMyAssets(),
        generalApiInterface.getMyFuelRequests(),
        generalApiInterface.getMyTrips(),
      ]);
    }else if(tokenData["user"]["type"] == UserType.towingOperator){
      // await Future.wait([
      //   getAppSettings(),
      //   setNotificationToken(),
      //   getProducts(),
      //   getOperatorOrders()
      // ]);
    }else if(tokenData["user"]["type"] == UserType.serviceProvider){
      // await Future.wait([
      //   getAppSettings(),
      //   setNotificationToken(),
      //   getProducts(),
      //   getDriverOrders()
      // ]);
    }
  }


  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool(SharedPrefKey.userIsLoggedIn, false);
    userIsLoggedIn.value = false;
    prefs.clear();

    // paymentMethods.clear();
    // await FirebaseMessaging.instance.unsubscribeFromTopic(tenantInformation["safeId"]);

    if (!Get.currentRoute.contains(const SignInScreen().runtimeType.toString())){
      Get.offAll(() => const SignInScreen());
    }
  }


  /// ******************************************************
  ///
  ///                    Pin code operations
  ///
  /// ******************************************************

  Future<bool> setPin({required String pin}) async{
    AuthApiInterface authApiInterface = AuthApiInterface();

    Globals.showLoadingDialog();
    final response = await authApiInterface.setPin(pin);
    Get.back();

    if(response.status){
      return true;
    }else{
      Globals.showErrorToast(response.message ?? "Error setting pin");
      return false;
    }
  }

  Future<bool> changePin({required String pin, required String oldPin}) async{
    AuthApiInterface authApiInterface = AuthApiInterface();

    Globals.showLoadingDialog();
    final response = await authApiInterface.changePin({"pin": pin, "old_pin": oldPin});
    Get.back();

    if(response.status){
      return true;
    }else{
      Globals.showErrorToast(response.message ?? "Error setting pin");
      return false;
    }
  }

  Future<bool> verifyPin({required String pin,}) async{
    AuthApiInterface authApiInterface = AuthApiInterface();

    Globals.showLoadingDialog();
    final response = await authApiInterface.verifyPin(pin);
    Get.back();

    if(response.status){
      return true;
    }else{
      Globals.showErrorToast(response.message ?? "Error verifying pin");
      return false;
    }
  }


  Future handleDeleteAccount() async {
    try{
      Globals.showLoadingDialog();
      AuthApiInterface authApiInterface = AuthApiInterface();
      var response = await authApiInterface.deleteAccount();
      Globals.hideLoadingDialog();

      if (response.status){
        await logout();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        Globals.successDialog(
          title: 'Done',
          content: Text('Account deleted',
            textAlign: TextAlign.center,
            style: TextStyle(color: Get.theme.colorScheme.onBackground),
          ),
          image: const Icon(Icons.check_circle, size: 40, color: Colors.green),
          okayTap: (){
            Get.back();
          },
        );

      }else{
        Globals.showErrorToast(response.message ?? "Something went wrong", title: "Failed");
      }
    }catch (e){
      print(e);
      Globals.hideLoadingDialog();
    }
  }

}