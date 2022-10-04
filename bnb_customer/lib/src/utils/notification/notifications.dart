import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bbblient/src/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const channelId = 'bnb_salon_admin';
const channelName = 'High Importance Notifications';

const icon = "@drawable/ic_stat_bnb_notification";
FirebaseMessaging messaging = FirebaseMessaging.instance;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  channelId, // channel_id
  channelName, // channel_name
  playSound: true,
  importance: Importance.high,
);

initializeNotifications() async {
  // Set the background messaging handler early on, as a named top-level function
  initBackgroundNotification();
  initForegroundNotification();

  /// Create an Android Notification Channel.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

initBackgroundNotification() {
  /// creates a background isolate, so this needs to be at the top-most level in tha application
  FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

  /// no need to call local_notification plugin, firebase handles background notifications itself
  /// after user opens up the app from terminated stage
  /// this function will fire
  //FirebaseMessaging.instance.getInitialMessage().then((value) => null);
}

Future<void> _onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
}

///initializing local notification plugin
_initLocalNotification() async {
  InitializationSettings _settings = const InitializationSettings(
      android: AndroidInitializationSettings(icon),
      iOS: IOSInitializationSettings());
  await flutterLocalNotificationsPlugin.initialize(_settings);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
}

initForegroundNotification() async {
  try {
    await _initLocalNotification();
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
  } catch (e) {
    printIt(e);
  }
}

_onForegroundMessage(RemoteMessage message) async {
  printIt('foreground cloud message callback called');
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name,
            icon: icon, priority: Priority.max),
      ),
    );
  }

  /// when the app is background bt opened and user taps on notification
  /// will not work if app is terminated
  //FirebaseMessaging.onMessageOpenedApp.listen((event) {//do something here if user taps on message });
}

askForNotificationPermission() async {
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}

// Replace with server token from firebase console settings.
const String serverToken =
    'AAAA72JGi3Y:APA91bHpPjkk7Ky3z9fRx5DsBlH2psHfZAi8IV-J2kPTg7sNju40jlI_k3P2eXIMhnP3rT6jvyvGEzVUlX5Tx6gyuIqxprRbskjGj6P0I10EJoCUpv4B6P2S_68RbzG_Zzv9fl1yP3Pl';

Future sendNotification(
    {final String title = '',
    final String body = '',
    required final String fcmToken}) async {
  await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': body,
          'title': title,
          "sound": "default"
        },
        'priority': 'high',
        'to': fcmToken,
        "android": {
          "notification": {'body': body, 'title': title, "sound": "default"}
        }
      },
    ),
  );
}
