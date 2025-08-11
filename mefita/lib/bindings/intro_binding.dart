import 'package:get/get.dart';
import 'package:mefita/services/global_controller.dart';
import 'package:mefita/services/helpers/theme_service.dart';

class IntroBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ThemeService());
    Get.put(GlobalController());
  }
} 