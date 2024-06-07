import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MessagingHandler {
  @pragma('vm:entry-point')
  static Future<void> handler(RemoteMessage message) async {
    // final notification = message.notification?.android;
    final plugin = FlutterLocalNotificationsPlugin();
    plugin.show(0, "title", "body", null);
    return;
  }

  static Future<void> initializePlugin() async {
    final plugin = FlutterLocalNotificationsPlugin();
    const settings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );
    await plugin.initialize(settings);
    return;
  }
}
