import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mefita/services/global_controller.dart';
import 'package:mefita/services/helpers/network_service.dart';
import 'package:mefita/utils/constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GeneralApiInterface{

  GlobalController globalController = Get.put(GlobalController());
  NetworkService generalNetworkService = NetworkService(userTokenRequired: false);

// ==============================================================================
// =========================== START FETCH ASSETS ===============================

  Future<dynamic> getMyAssets() async {
    print("==== Start fetch assets ====");
    RequestResponseData responseData = await generalNetworkService.getRequest(url: URLs.getMyAssets);
    // log("Assets Data: ${responseData.data}");
    if (responseData.status) {
      globalController.myAssets.clear();
      globalController.myAssets.addAll(responseData.data);
      // log("Assets fetched successfully: ${globalController.myAssets.length} assets");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(SharedPrefKey.myAssets, jsonEncode(globalController.myAssets));
    } else {
      log("Error fetching assets");
    }
    print("==== End fetch assets ====");
    return responseData;
  }

// ============================ END FETCH ASSETS  ===============================
// ==============================================================================

// ==============================================================================
// =========================== START FETCH ASSETS ===============================

  Future<dynamic> getMyFuelRequests() async {
    print("==== Start fetch fuel requests ====");
    RequestResponseData responseData = await generalNetworkService.getRequest(url: URLs.getMyFuelRequests);
    // log("Assets Data: ${responseData.data}");
    if (responseData.status) {
      globalController.fuelRequestHistory.clear();
      globalController.fuelRequestHistory.addAll(responseData.data);
      // log("Fuel requests fetched successfully: ${globalController.fuelRequestHistory.length} assets");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(SharedPrefKey.fuelRequestHistory, jsonEncode(globalController.fuelRequestHistory));
    } else {
      log("Error fetching fuel requests");
    }
    print("==== End fetch fuel requests ====");
    return responseData;
  }

// ============================ END FETCH ASSETS  ===============================
// ==============================================================================

// ==============================================================================
// =========================== START FUEL REQUEST ===============================

  Future<dynamic> submitFuelRequest(dynamic data) async {
    print("==== Start fuel request ====");
    RequestResponseData responseData = await generalNetworkService.postRequest(url: URLs.submitFuelRequest, data: data, contentType: 'multipart/form-data');
    log("submitFuelRequest: ${responseData.message}");
    if (responseData.status) {
      await getMyFuelRequests();
    } else {
      log("Error submitting fuel request: ${responseData.message}");
    }
    print("==== End submit fuel request ====");
    return responseData;
  }

// ============================ END FUEL REQUEST  ===============================
// ==============================================================================

// ==============================================================================
// =========================== START CANCEL FUEL REQUEST ===============================

  Future<dynamic> cancelFuelRequest(var data) async {
    print("==== Start cancel fuel request ====");
    RequestResponseData responseData = await generalNetworkService.postRequest(url: URLs.cancelFuelRequest, data: data);
    log("cancelFuelRequest: ${responseData.message}");
    if (responseData.status) {
      await getMyFuelRequests();
    } else {
      log("Error cancelling fuel request");
    }
    print("==== End cancel submit fuel request ====");
    return responseData;
  }

// ============================ END CANCEL FUEL REQUEST  ===============================
// ==============================================================================

// ==============================================================================
// =========================== START GET NEARBY FUEL STATIONS ===============================

  Future<RequestResponseData> getNearbyFuelStations(var data) async {
    print("==== Start get nearby fuel station ====");
    RequestResponseData responseData = await generalNetworkService.postRequest(url: URLs.getNearbyFuelStations, data: data);
    log("getNearbyFuelStations: ${responseData.message}");
    if (responseData.status) {
      globalController.nearbyFuelStations.clear();
      globalController.nearbyFuelStations.addAll(responseData.data);
    } else {
      log("Error getting nearby fuel station");
    }
    print("==== End get nearby fuel station ====");
    return responseData;
  }

// ============================ END GET NEARBY FUEL STATIONS  ===============================
// ==============================================================================

// ==============================================================================
// =========================== START FETCH TRIPS ===============================

  Future<dynamic> getMyTrips() async {
    print("==== Start fetch trips ====");
    RequestResponseData responseData = await generalNetworkService.getRequest(url: URLs.getMyTrips);
    // log("Assets Data: ${responseData.data}");
    if (responseData.status) {
      globalController.tripHistory.clear();
      globalController.tripHistory.addAll(responseData.data);
      // log("Fuel requests fetched successfully: ${globalController.tripHistory.length} assets");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(SharedPrefKey.tripHistory, jsonEncode(globalController.tripHistory));
    } else {
      log("Error fetching trips");
    }
    print("==== End fetch trips ====");
    return responseData;
  }

// ============================ END FETCH TRIP  ===============================
// ==============================================================================

// ==============================================================================
// =========================== START START TRIP ===============================

  Future<RequestResponseData> submitStartTrip(var data) async {
    print("==== Start start trip ====");
    RequestResponseData responseData = await generalNetworkService.postRequest(url: URLs.startTrip, data: data);
    log("submitStartTrip: ${responseData.message}");
    if (responseData.status) {
      await getMyTrips();
    } else {
      log("Error submitting start trip");
    }
    print("==== End start trip ====");
    return responseData;
  }

// ============================ END START TRIP  ===============================
// ==============================================================================

// ==============================================================================
// =========================== START END TRIP ===============================

  Future<RequestResponseData> submitEndTrip(var data) async {
    print("==== Start end trip ====");
    RequestResponseData responseData = await generalNetworkService.patchRequest(url: URLs.endTrip, data: data);
    log("submitEndTrip: ${responseData.message}");
    if (responseData.status) {
      await getMyTrips();
    } else {
      log("Error submitting end trip");
    }
    print("==== End end trip ====");
    return responseData;
  }

// ============================ END END TRIP  ===============================
// ==============================================================================

// ==============================================================================
// =========================== START GET COUPON BY CODE ===============================

  Future<RequestResponseData> getCouponByCode(var data) async {
    print("==== Start submit coupon code ====");
    RequestResponseData responseData = await generalNetworkService.postRequest(url: URLs.getCouponByCode, data: data);
    // log("getCouponByCode: ${responseData.message}");
    log(responseData.data.toString());
    if (responseData.status) {
      globalController.currentCouponData.value = responseData.data;
    } else {
      log("Error getting coupon by code");
    }
    print("==== End get coupon by code ====");
    return responseData;
  }

// ============================ END GET COUPON BY CODE  ===============================
// ==============================================================================

// ==============================================================================
// =========================== START AUTHORIZE COUPON WITH DRIVER PIN ===============================

  Future<RequestResponseData> authorizeCouponRedemptionWithDriverPin(var data) async {
    print("==== Start authorize coupon with driver pin ====");
    RequestResponseData responseData = await generalNetworkService.postRequest(url: URLs.authorizeCouponRedemptionWithDriverCode, data: data);
    // log("getCouponByCode: ${responseData.message}");
    // log(responseData.data.toString());
    if (responseData.status) {
      log("Driver authorized successfully");
    } else {
      log("Error authorizing coupon with driver pin");
    }
    print("==== End authorize coupon with driver pin ====");
    return responseData;
  }

// ============================ END AUTHORIZE COUPON WITH DRIVER PIN  ===============================
// ==============================================================================

// ==============================================================================
// =========================== START FETCH MY COUPON REDEMPTIONS ===============================

  Future<dynamic> getMyCouponRedemptions() async {
    print("==== Start fetch my coupon redemptions ====");
    RequestResponseData responseData = await generalNetworkService.getRequest(url: URLs.getMyCouponRedemptions);
    // log("Assets Data: ${responseData.data}");
    if (responseData.status) {
      globalController.couponRedemptions.clear();
      globalController.couponRedemptions.addAll(responseData.data);
      // log("Fuel requests fetched successfully: ${globalController.couponRedemptions.length} assets");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(SharedPrefKey.couponRedemptions, jsonEncode(globalController.couponRedemptions));
    } else {
      log("Error fetching my coupon redemptions");
    }
    print("==== End fetch my coupon redemptions ====");
    return responseData;
  }

// ============================ END FETCH MY COUPON REDEMPTIONS  ===============================
// ==============================================================================

// ==============================================================================
// =========================== START COMPLETE FUEL REDEMPTION ===============================

  Future<RequestResponseData> completeFuelRedemption(dynamic data) async {
    print("==== Start complete fuel redemption ====");
    RequestResponseData responseData = await generalNetworkService.postRequest(url: URLs.completeFuelRedemption, data: data, contentType: 'multipart/form-data');
    log("completeFuelRedemption: ${responseData.message}");
    // log(responseData.data.toString());
    if (responseData.status) {
      await getMyCouponRedemptions();
    } else {
      log("Error completing fuel redemption");
    }
    print("==== End complete fuel redemption ====");
    return responseData;
  }

// ============================ END COMPLETE FUEL REDEMPTION  ===============================
// ==============================================================================

}
