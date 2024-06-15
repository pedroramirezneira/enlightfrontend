package com.enlight.android

import com.enlight.android.messaging.NotificationCallHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        val name = "com.enlight.android.messaging/notification_service"
        val channel = MethodChannel(messenger, name)
        val handler = NotificationCallHandler(this)
        channel.setMethodCallHandler(handler)
    }
}
