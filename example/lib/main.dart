/// The main entry point for the Flutter application, demonstrating the integration
/// of the Tawk.to chat service with local notifications and state management using GetX.
import 'package:flutter/material.dart';
import 'package:flutter_tawk/flutter_tawk.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

/// Entry point of the application.
void main() {
  // Ensures that the Flutter engine is initialized before using any plugins.
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes the notification service for handling Tawk.to agent messages.
  TawkNotificationService().initialize();

  // Runs the main application widget.
  runApp(const MyApp());
}

/// The root widget of the application, setting up the material design structure
/// and theme using GetX for state management.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

/// A GetX controller to manage global state, specifically tracking unread messages
/// from Tawk.to agents.
class GlobalStateController extends GetxController {
  // Observable variable to track the number of unread messages.
  RxInt unreadMessages = 0.obs;
}

/// The main home page widget, displaying the number of unread messages and a button
/// to navigate to the help screen with the Tawk.to chat.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// The state class for MyHomePage, managing the UI and navigation.
class _MyHomePageState extends State<MyHomePage> {
  // Injects the GlobalStateController using GetX for state management.
  GlobalStateController globalController = Get.put(GlobalStateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Flutter Tawk Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Displays the current count of unread messages, updated reactively.
            Obx(() => Text(
              'Unread Messages: ${globalController.unreadMessages.value}',
              style: Theme.of(context).textTheme.labelMedium,
            )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Resets unread messages count when navigating to the help screen.
                globalController.unreadMessages.value = 0;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpScreen()),
                );
              },
              child: const Text('Go to Help Screen'),
            ),
          ],
        ),
      ),
    );
  }
}

/// The help screen widget, displaying the Tawk.to chat interface.
class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

/// The state class for HelpScreen, embedding the Tawk.to chat widget.
class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Help Screen"),
      ),
      body: TawkService().getWebViewWidget(
        // Displays a loading indicator while the Tawk.to chat widget loads.
        placeholder: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

/// A singleton service for managing local notifications triggered by Tawk.to agent messages.
class TawkNotificationService {
  // Private singleton instance of the notification service.
  static final TawkNotificationService _instance = TawkNotificationService._internal();
  factory TawkNotificationService() => _instance;
  TawkNotificationService._internal();

  // Instance of the local notifications plugin.
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// Initializes the notification service and Tawk.to chat service.
  Future<void> initialize() async {
    // Configures notification settings for Android and iOS.
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );

    // Initializes the notifications plugin with the specified settings.
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotificationResponse,
    );

    // Subscribes to agent messages via the event bus and triggers notifications.
    eventBus.on<AgentMessageEvent>().listen((event) {
      print("EVENTBUS:: Received Agent Message: ${event.message}");
      _showNotification(event.message);
      // Increments the unread messages count in the global state.
      Get.find<GlobalStateController>().unreadMessages.value++;
    });

    // Requests notification permissions for Android.
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // Initializes the Tawk.to chat service with visitor details and callbacks.
    TawkService().initialize(
      directChatLink: 'https://tawk.to/chat/664106a907f59932ab3eb7ca/1htn042na',
      visitor: TawkVisitor(
        name: "John Doe",
        email: "john@mail.com",
        secret: "35b25402c0baba33492e26c9623768ec1b55301c",
        otherAttributes: {
          "user-id": "some_unique_user_id",
          "phone-number": "some_phone_number",
        },
      ),
      onAgentMessage: (message) {
        print('Agent message (callback): $message');
      },
    );
  }

  /// Displays a local notification with the provided message.
  ///
  /// Parameters:
  /// - `message`: The message content to display in the notification.
  Future<void> _showNotification(String message) async {
    const androidDetails = AndroidNotificationDetails(
      'tawk_channel',
      "Alert",
      channelDescription: "This channel is responsible for all the local notifications",
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const platformDetails = NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(
      0,
      'Tawk Support',
      message,
      platformDetails,
    );
  }
}

/// Handles notification tap events, navigating to the HelpScreen and resetting
/// the unread messages count.
void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  try {
    // Resets unread messages and navigates to the HelpScreen.
    Get.find<GlobalStateController>().unreadMessages.value = 0;
    Get.to(() => HelpScreen());
  } catch (e) {
    print("Error handling notification response: $e");
  }
}