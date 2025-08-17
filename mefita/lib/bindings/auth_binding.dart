import 'package:get/get.dart';
import 'package:mefita/services/global_controller.dart';
import 'package:mefita/services/helpers/theme_service.dart';
import 'package:mefita/ui/global/auth/signin/signin_controller.dart';
import 'package:mefita/ui/global/auth/signup/signup_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ThemeService());
    Get.put(GlobalController());
    Get.put(SignInController());
    Get.put(SignUpController());
  }
}
