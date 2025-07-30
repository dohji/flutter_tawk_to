import 'package:flutter/material.dart';
import 'package:flutter_tawk/flutter_tawk.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

void main() {

  // Ensure that the Flutter engine is initialized before using any plugins
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the notification service
  TawkNotificationService().initialize();

  runApp(const MyApp());
}

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

// Global state controller to manage Tawk visibility
class GlobalStateController extends GetxController{
  RxInt unreadMessages = 0.obs;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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
            Obx(() => Text(
              'Unread Messages: ${globalController.unreadMessages.value}',
              style: Theme.of(context).textTheme.labelMedium,
            )),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  globalController.unreadMessages.value = 0; // Reset unread messages when entering help screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HelpScreen()),
                  );
                },
                child: const Text('Go to Help Screen')
            ),
          ],
        ),
      ),

    );
  }
}


// Help screen
class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Help Screen"),
      ),
      body: TawkService().getWebViewWidget(
        placeholder: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}




// If you want to use notifications, you can implement a notification service like this:
class TawkNotificationService {
  static final TawkNotificationService _instance = TawkNotificationService._internal();
  factory TawkNotificationService() => _instance;
  TawkNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Initialize notifications
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotificationResponse,
    );

    // Subscribe to agent messages
    eventBus.on<AgentMessageEvent>().listen((event) {
      print("EVENTBUS:: Received Agent Message: ${event.message}");
      _showNotification(event.message);
      // Increment unread messages count
      Get.find<GlobalStateController>().unreadMessages.value++;
    });

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

    TawkService().initialize(
      directChatLink: 'https://tawk.to/chat/664106a907f59932ab3eb7ca/1htn042na',
      visitor: TawkVisitor(
        name: "John Doe",
        email: "john@mail.com",
        secret: "35b25402c0baba33492e26c9623768ec1b55301c",
        // secret: "your_tawk_secret_key_here", // Replace with actual secret key
        otherAttributes: {
          "user-id": "some_unique_user_id", // Replace with actual user ID
          "phone-number": "some_phone_number", // Replace with actual phone number
        },
      ),
      onAgentMessage: (message) {
        print('Agent message (callback): $message');
      },
    );

  }

  Future<void> _showNotification(String message) async {
    const androidDetails = AndroidNotificationDetails(
        'tawk_channel',
        "Alert",
        channelDescription: "This channel is responsible for all the local notifications",
        playSound: true,
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher'
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

void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  // Handle notification tap => show the Tawk widget - Toggle the visibility of the Tawk widget from your global state controller
  try{
    Get.find<GlobalStateController>().unreadMessages.value = 0; // Reset unread messages when notification is tapped
    Get.to(() => HelpScreen());
  }catch (e) {
    print("Error handling notification response: $e");
  }
}