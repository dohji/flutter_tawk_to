import 'package:flutter/material.dart';
import 'package:mefita/services/api/auth_apis.dart';
import 'package:mefita/services/global_controller.dart';
import 'package:mefita/ui/global/helpers/globals.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInController extends GetxController{

  AuthApiInterface authApiInterface = AuthApiInterface();
  GlobalController globalController = Get.find();

  TextEditingController emailTC = TextEditingController();
  TextEditingController passwordTC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(milliseconds: 400), () {
      // Globals.showLoadingDialog();
    });
  }

  Future handleSignIn() async {
    var data = {
      "email": emailTC.text.trim(),
      "password": passwordTC.text.trim()
    };

    Globals.showLoadingDialog();
    var loginResponse = await authApiInterface.logUserIn(data);
    // Get.back();

    if (loginResponse.status){
      globalController.redirectUser(hasLoadingIndicator: true);
    }else{
      Get.back();
      Globals.showErrorToast(loginResponse.message ?? "Could not login", title: "Failed");
    }
  }

}