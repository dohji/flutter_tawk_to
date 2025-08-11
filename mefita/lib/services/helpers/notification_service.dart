import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';


class NotificationService {
  // Singleton pattern
  static final NotificationService _notificationService =
  NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }


  NotificationService._internal();

  static const channelId = "fds_notification_channel";

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static const AndroidNotificationDetails _androidNotificationDetails =
  AndroidNotificationDetails(
      channelId,
      "Alert",
      channelDescription: "This channel is responsible for all the local notifications",
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
      // largeIcon: DrawableResourceAndroidBitmap('@drawable/ic_launcher_foreground'),
      icon: '@mipmap/launcher_icon',
  );

  // Updated iOS notification details with proper foreground settings
  static const DarwinNotificationDetails _iOSNotificationDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  final NotificationDetails notificationDetails = const NotificationDetails(
    android: _androidNotificationDetails,
    iOS: _iOSNotificationDetails,
  );

  Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidInitializationSettings,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotificationResponse,
    );

    // Configure Firebase for iOS foreground notifications
    // Set to false so we handle notifications manually via local notifications
    // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    //   alert: false,  // Changed to false
    //   badge: true,
    //   sound: false,  // Changed to false - we'll handle sound via local notifications
    // );
  }

  Future<void> showNotification(
      int id, String title, String body, String payload) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  handleRemoteMessage(RemoteMessage remoteMessage) async {
    var data = remoteMessage.data;

    // Add null checks and default values
    String title = remoteMessage.notification?.title ?? 'New Notification';
    String body = remoteMessage.notification?.body ?? 'You have a new message';

    await showNotification(
      Random().nextInt(1000),
      title,
      body,
      jsonEncode(data),
    );
  }

  // Future<void> playSound() async {
  //   try {
  //     // For assets
  //     await Future.wait([
  //       _audioPlayer.play(AssetSource('sounds/notification.mp3')),
  //       HapticFeedback.mediumImpact(),
  //     ]);
  //     print('Notification sound played');
  //     // Or for system sounds (Android)
  //   } catch (e) {
  //     print('Error playing notification sound: $e');
  //   }
  // }


}

//iOS - Updated signature to match the required callback
void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
  // display a dialog with the notification details, tap ok to go to another page
  print('iOS Local Notification: $title - $body');
}

//Android
void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  print('Notification tapped with payload: $payload');
}