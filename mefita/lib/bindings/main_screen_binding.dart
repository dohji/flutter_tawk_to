import 'package:get/get.dart';
import 'package:mefita/services/global_controller.dart';
import 'package:mefita/services/helpers/theme_service.dart';

class MainScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ThemeService());
    // Get.put(MainScreenController());
    Get.put(GlobalController());
  }
} 