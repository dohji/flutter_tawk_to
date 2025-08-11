import 'package:get/get.dart';
import 'package:mefita/bindings/splash_binding.dart';
import 'package:mefita/ui/global/start/splash.dart';
import 'route_middleware.dart';

class AppRoutes {
  // Route names
  static const String splash = '/splash';
  static const String intro = '/intro';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String main = '/main';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Route definitions
  static final List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
      // middlewares: [Get.find<RouteMiddleware>()],
    ),
    // GetPage(
    //   name: intro,
    //   page: () => const IntroScreen(),
    //   binding: IntroBinding(),
    //   middlewares: [Get.find<RouteMiddleware>()],
    // ),
    // GetPage(
    //   name: login,
    //   page: () => const LoginScreen(),
    //   binding: AuthBinding(),
    //   middlewares: [Get.find<RouteMiddleware>()],
    // ),
    // GetPage(
    //   name: forgotPassword,
    //   page: () => const ForgotPasswordScreen(),
    //   binding: AuthBinding(),
    //   middlewares: [Get.find<RouteMiddleware>()],
    // ),
    // GetPage(
    //   name: home,
    //   page: () => const HomeScreen(),
    //   binding: AuthBinding(),
    //   middlewares: [Get.find<RouteMiddleware>()],
    // ),
    // GetPage(
    //   name: onboardingFlow,
    //   page: () => const OnboardingFlowScreen(),
    //   binding: OnboardingFlowBinding(),
    //   middlewares: [Get.find<RouteMiddleware>()],
    // ),
    // GetPage(
    //   name: main,
    //   page: () => MainScreen(),
    //   binding: MainScreenBinding(),
    //   middlewares: [Get.find<RouteMiddleware>()],
    // ),
  ];

  // Navigation methods
  static Future<T?> toNamed<T>(String routeName, {Object? arguments}) {
    return Get.toNamed<T>(routeName, arguments: arguments) ?? Future.value(null);
  }

  static Future<T?> offNamed<T>(String routeName, {Object? arguments}) {
    return Get.offNamed<T>(routeName, arguments: arguments) ?? Future.value(null);
  }

  static Future<T?> offAllNamed<T>(String routeName, {Object? arguments}) {
    return Get.offAllNamed<T>(routeName, arguments: arguments) ?? Future.value(null);
  }

  static void back<T>({T? result}) {
    Get.back<T>(result: result);
  }

}
