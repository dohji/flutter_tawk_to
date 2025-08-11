import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:mefita/services/global_controller.dart';
import 'package:mefita/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart' as get_x;

import 'connection_verify.dart';

class TokenService {
  Dio? _dio;

  GlobalController globalController = get_x.Get.find();

  TokenService() {
    _dio = Dio(BaseOptions(
      baseUrl: URLs.baseUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    (_dio?.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };
  }

  Future<RequestResponseData> postRequest({required String url, dynamic data}) async {
    // GlobalController globalController = get_x.Get.find();
    if (await ConnectionVerify.connectionIsAvailable()) {
      // print( "globalController.authToken.app");
      // print( URLs.baseUrl);
      // print( globalController.authToken.app);
      try {
        _dio?.options.headers.addAll({
          'Authorization': 'Bearer ${globalController.tokenData["token"]}',
        });
        // print(_dio?.options.headers);
        var response = await _dio?.post(url, data: data);
        return RequestResponseData(
            status: response?.data['status'] == "success" ? true : false,
            data: response?.data['data'],
            message: response?.data['message'],
            connectionAvailable: true
        );
      } catch (e) {
        print('***** Error submitting request *****');
        print(e);
        return RequestResponseData(
            status: false,
            data: null,
            message: 'Error submitting request',
            connectionAvailable: true
        );
      }
    } else {
      return RequestResponseData(
          status: false,
          data: null,
          message: 'Unable to connect to the internet. Please check your network connectivity',
          connectionAvailable: false
      );
    }
  }

  Future<RequestResponseData> refreshUserToken() async {
    // GlobalController globalController = get_x.Get.find();
    print("==== Refreshing User Token ====");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedData = prefs.getString(SharedPrefKey.tokenData);
    Map<String, dynamic> data = {};
    if(storedData != null){
      data = jsonDecode(storedData);
      // print("refreshUserToken(): Stored Token Data: $data");
    }

    RequestResponseData res = await postRequest(
      url: URLs.refreshUserToken, data: {
      'refresh_token': data["refresh_token"],
    });

    if (res.status == true) {
      globalController.tokenData = res.data;
      globalController.tokenData["expiry_time"] = DateTime.now().millisecondsSinceEpoch + res.data["expires_in"];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(SharedPrefKey.tokenData, jsonEncode(globalController.tokenData));

      print("==== User Token Refreshed ====");
    }
    return res;
  }

}