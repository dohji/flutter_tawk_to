import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:mefita/services/global_controller.dart';
import 'package:mefita/services/helpers/token_service.dart';
import 'package:mefita/utils/constants.dart';
import 'package:get/get.dart' as get_x;

import 'connection_verify.dart';

class NetworkService {
  Dio? _dio;
  bool _isRefreshing = false;
  final List<Completer<Response<dynamic>>> _requestQueue = [];
  final bool userTokenRequired;

  GlobalController globalController = get_x.Get.find();
  TokenService tokenService = TokenService();

  NetworkService({this.userTokenRequired = true}) {
    _dio = Dio(BaseOptions(
      baseUrl: URLs.baseUrl,
      validateStatus: (_) => true,
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


    // Add token interceptors
    _dio?.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Check and refresh tokens if needed
        if (await ConnectionVerify.connectionIsAvailable()) {
          if (_isRefreshing) {
            // If a token refresh is in progress, queue the request
            Completer<Response<dynamic>> completer = Completer();
            _requestQueue.add(completer);
            await completer.future;
          } else {

            // Check and refresh user token if needed
            if (userTokenRequired && userTokenExpired()) {
              await _refreshUserToken();
            }

            // Add tokens to headers
            options.headers.addAll({
              'Authorization': 'Bearer ${globalController.tokenData["token"]}',
            });

            // Proceed with the request
            // print('Request: ${options.uri}');
            handler.next(options);
          }
        } else {
          // Handle network unavailable scenario
          handler.reject(DioException(
            requestOptions: options,
            error: 'Unable to connect to the internet. Please check your network connectivity',
          ));
        }
      },
    ));
  }

  Future<void> _refreshUserToken() async {
    _isRefreshing = true;
    RequestResponseData res = await tokenService.refreshUserToken();
    if (res.status == false){
      _requestQueue.clear();
      globalController.logout();
      // Globals.showInfoToast("Your session has expired. Please login again");
    }
    // Resolve queued requests with the new user token
    _resolveRequests();
  }

  void _resolveRequests() {
    _isRefreshing = false;

    for (var completer in _requestQueue) {
      var response = Response<dynamic>(requestOptions: RequestOptions(path: ''), data: null);
      completer.complete(response);
      // completer.complete();
    }
    _requestQueue.clear();
  }

  bool userTokenExpired() {
    if (globalController.tokenData["expiry_time"] == null){
      return false;
    }else if (DateTime.now().millisecondsSinceEpoch >= (globalController.tokenData["expiry_time"] ?? 0)) {
      return true;
    }else{
      return false;
    }
  }


  Future<RequestResponseData> postRequest({required String url, dynamic data, String? contentType}) async {
    if (await ConnectionVerify.connectionIsAvailable()){
      try {
        _dio?.options.headers.addAll({
          'Authorization': 'Bearer ${globalController.tokenData["token"] ?? ""}',
        });
        if (contentType != null) {
          _dio?.options.contentType = contentType;
        }else{
          _dio?.options.contentType = 'application/json';
        }
        var response = await _dio?.post(url, data: data);

        if ( response?.data['status'] == "error"){
          if (response?.data['message'] == "Unauthorized"){
            await _refreshUserToken();
            response = await _dio?.post(url, data: data);
          }
        }

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
    }else{
      return RequestResponseData(
          status: false,
          data: null,
          message: 'Unable to connect to the internet. Please check your network connectivity',
          connectionAvailable: false
      );
    }
  }


  Future<RequestResponseData> patchRequest({required String url, dynamic data}) async {
    if (await ConnectionVerify.connectionIsAvailable()){
      try {
        _dio?.options.headers.addAll({
          'Authorization': 'Bearer ${globalController.tokenData["token"]}',
        });
        var response = await _dio?.patch(url, data: data);
        // print(response?.data);

        if ( response?.data['status'] == "error"){
          if (response?.data['message'] == "Unauthorized"){
            await _refreshUserToken();
            response = await _dio?.patch(url, data: data);
          }
        }

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
    }else{
      return RequestResponseData(
          status: false,
          data: null,
          message: 'Unable to connect to the internet. Please check your network connectivity',
          connectionAvailable: false
      );
    }
  }


  Future<RequestResponseData> getRequest({required String url, Map<String, dynamic>? queryParameters}) async {
    if (await ConnectionVerify.connectionIsAvailable()){
      try {
        _dio?.options.headers.addAll({
          'Authorization': 'Bearer ${globalController.tokenData["token"]}',
        });
        var response = await _dio?.get(url, queryParameters: queryParameters);
        if ( response?.data['status'] == "error"){
          if (response?.data['message'] == "Unauthorized"){
            await _refreshUserToken();
            response = await _dio?.get(url);
          }
        }

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
    }else{
      return RequestResponseData(
          status: false,
          data: null,
          message: 'Unable to connect to the internet. Please check your network connectivity',
          connectionAvailable: false
      );
    }
  }


  Future<RequestResponseData> deleteRequest({required String url, Map<String, dynamic>? queryParameters}) async {
    if (await ConnectionVerify.connectionIsAvailable()){
      try {
        _dio?.options.headers.addAll({
          'Authorization': 'Bearer ${globalController.tokenData["token"]}',
        });
        var response = await _dio?.delete(url, queryParameters: queryParameters);

        if ( response?.data['status'] == "error"){
          if (response?.data['message'] == "Unauthorized"){
            await _refreshUserToken();
            response = await _dio?.delete(url);
          }
        }

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
    }else{
      return RequestResponseData(
          status: false,
          data: null,
          message: 'Unable to connect to the internet. Please check your network connectivity',
          connectionAvailable: false
      );
    }
  }


}
