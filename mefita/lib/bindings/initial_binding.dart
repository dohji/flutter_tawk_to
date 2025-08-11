import 'package:get/get.dart';
import 'package:mefita/services/global_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put(AuthController());
    Get.put(GlobalController());
    // Get.lazyPut(() => OnboardingFlowController(), fenix: true);
  }
} 