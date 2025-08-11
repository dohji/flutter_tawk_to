import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mefita/services/api/auth_apis.dart';
import 'package:mefita/services/api/general_apis.dart';
import 'package:get/get.dart';

import 'notification_service.dart';

class FirebaseNotificationHelper{

  static requestNotificationPermission() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      await NotificationService().init();

      // CRITICAL: Completely disable Firebase's automatic foreground notifications
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: false,
        badge: false,  // Set to false to prevent any automatic display
        sound: false,
      );
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
      await NotificationService().init();

      // CRITICAL: Completely disable Firebase's automatic foreground notifications
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: false,
        badge: false,  // Set to false to prevent any automatic display
        sound: false,
      );
    } else {
      print('User declined or has not accepted permission');
    }
  }

  static Future<String?> getNotificationToken() async{
    return await FirebaseMessaging.instance.getToken();
  }

  static initializeForegroundNotifications(){
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message notification title: ${message.notification!.title}');
        print('Message notification body: ${message.notification!.body}');

        // Only handle the message operations and show our custom notification
        // Firebase's automatic notification is disabled via setForegroundNotificationPresentationOptions
        _handleForegroundMessage(message);
      }
    });

    // Handle notification taps when app is in background/terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');
      _handleNotificationTap(message);
    });

    // Handle initial message when app is launched from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('App launched from notification!');
        print('Message data: ${message.data}');
        _handleNotificationTap(message);
      }
    });
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    // Handle business logic
    handleMessageOperations(message);

    // Show our custom local notification
    // This is the ONLY notification that will be shown since Firebase's is disabled
    NotificationService().handleRemoteMessage(message);

    print('Handled foreground notification: ${message.notification?.title}');
  }

  static void _updateAppState(RemoteMessage message) {
    print('Updating app state with new data: ${message.data}');
  }

  static void _handleNotificationTap(RemoteMessage message) {
    print('Notification tapped: ${message.data}');
    // Handle navigation logic here
  }

  static handleMessageOperations(RemoteMessage message) async {
    String role = message.data['user_role'] ?? '';
    GeneralApiInterface generalApiInterface = GeneralApiInterface();
    AuthApiInterface authApiInterface = AuthApiInterface();

    if (role == "driver") {
      await Future.wait([
        authApiInterface.getUserProfile(),
        generalApiInterface.getMyAssets(),
        generalApiInterface.getMyFuelRequests(),
        generalApiInterface.getMyTrips(),
      ]);
      print('Handle driver notifications');
    } else if (role == "pump_attendant") {
      await Future.wait([
        authApiInterface.getUserProfile(),
        generalApiInterface.getMyCouponRedemptions()
      ]);
      print('Handle pump attendant notifications');
    } else if (role == "delivery_agent") {
      print('Handle delivery agent notifications');
    } else if (role == "customer") {
      print('Handle customer notifications');
    } else {
      print('Handling general notification');
    }
  }
}