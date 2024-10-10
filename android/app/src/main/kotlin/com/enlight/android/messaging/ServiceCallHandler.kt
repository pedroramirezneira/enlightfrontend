package com.enlight.android.messaging

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.os.Build
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

class ServiceCallHandler(private val context: Context) : MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "startService" -> {
                val intent = createIntent(call)
                val isForeground = Build.VERSION.SDK_INT >= Build.VERSION_CODES.O
                when {
                    isServiceRunning() -> none()
                    isForeground -> context.startForegroundService(intent)
                    else -> context.startService(intent)
                }
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

    private fun createIntent(call: MethodCall): Intent {
        val accountId = call.argument<Int>("accountId")
        val receiverIds = call.argument<List<Int>>("receiverIds")
        val list = ArrayList<Int>()
        receiverIds?.let { list.addAll(it) }
        return Intent(context, NotificationService::class.java).apply {
            putExtra("accountId", accountId)
            putIntegerArrayListExtra("receiverIds", list)
        }
    }

    private fun isServiceRunning(): Boolean {
        val manager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        for (service in manager.getRunningServices(Int.MAX_VALUE)) {
            if (NotificationService::class.java.name == service.service.className) {
                return true
            }
        }
        return false
    }

    private fun none() {}
}
