package com.enlight.android.messaging

import android.app.NotificationManager
import android.content.Context
import androidx.core.app.NotificationCompat
import com.enlight.android.R
import com.enlight.android.messaging.models.Message

object NotificationHandler {
    fun sendNotification(context: Context, message: Message) {
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        NotificationService.ensureNotificationChannelExists(manager)
        val notification = buildNotification(context, message)
        val summaryNotification = buildSummaryNotification(context, message)
        manager.notify(System.identityHashCode(message), notification)
        manager.notify(message.sender_id, summaryNotification)
    }

    private fun buildNotification(
        context: Context,
        message: Message
    ) = NotificationCompat.Builder(context, "notifications")
        .setSmallIcon(R.mipmap.ic_launcher)
        .setGroup(message.sender_id.toString())
        .setContentText(message.message)
        .setPriority(NotificationCompat.PRIORITY_HIGH)
        .setStyle(null)
        .build()

    private fun buildSummaryNotification(context: Context, message: Message) =
        NotificationCompat.Builder(context, "notifications")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setGroup(message.sender_id.toString())
            .setGroupSummary(true)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .build()
}
