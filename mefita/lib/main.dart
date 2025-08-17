import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mefita/routes/app_routes.dart';
import 'package:mefita/routes/route_middleware.dart';
import 'package:mefita/services/global_controller.dart';
import 'package:mefita/services/helpers/firebase_notification_helper.dart';
import 'package:mefita/services/helpers/notification_service.dart';
import 'package:mefita/services/helpers/theme_service.dart';
import 'package:mefita/services/helpers/translation_service.dart';

import 'bindings/initial_binding.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling background message: ${message.messageId}');

  // Show system notification for background
  NotificationService().handleRemoteMessage(message);
}


Future<void> main() async{
  runZonedGuarded<Future<void>>(() async {

    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    print('✅ Firebase initialized');

    GlobalController globalController = Get.put(GlobalController());

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Set up background message handler first
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Request permission and initialize notifications
    await FirebaseNotificationHelper.requestNotificationPermission();

    // Initialize foreground notification handling
    FirebaseNotificationHelper.initializeForegroundNotifications();

    await globalController.getAppSetup();

    // Initialize services
    await Get.putAsync(() => ThemeService().init());
    await Get.putAsync(() => TranslationService().init());

    // Initialize route middleware
    final routeMiddleware = Get.put(RouteMiddleware());
    // await routeMiddleware.checkAuthStatus();

    runApp(const MyApp());

  }, (error, stack) => FirebaseCrashlytics.instance.recordError(
    error,
    stack,
    fatal: true,
  ),
  );
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      title: 'Mefita',
      defaultTransition: Transition.rightToLeft,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // colorSchemeSeed: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffF15831)).copyWith(
          primary: const Color(0xffF15831),
        ),
        // brightness: Brightness.light,
        fontFamily: 'Poppins',
      ),
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,
      routingCallback: (routing) {
        Get.find<RouteMiddleware>().checkAuthStatus();
      },
    );
  }
}
