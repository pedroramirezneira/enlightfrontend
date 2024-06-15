import 'package:enlight/services/messaging_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NotificationService {
  static const _platform = MethodChannel(
    "com.enlight.android.messaging/notification_service",
  );

  static Future<void> start(BuildContext context) async {
    final chats = await context.read<MessagingService>().chats;
    if (chats == null) {
      debugPrint("Failed to start service: Chats have not been loaded.");
      return;
    }
    final accountId = chats.accountId;
    final receiverIds = chats.chats.map(
      (e) => e.id,
    );
    try {
      await _platform.invokeMethod("startService", {
        "accountId": accountId,
        "receiverIds": receiverIds.toList(),
      });
      debugPrint("Started notification service");
    } on PlatformException catch (e) {
      debugPrint("Failed to start service: '${e.message}'.");
    }
  }

  static Future<void> stop() async {
    try {
      await _platform.invokeMethod("stopService");
    } on PlatformException catch (e) {
      debugPrint("Failed to start service: '${e.message}'.");
    }
  }
}
