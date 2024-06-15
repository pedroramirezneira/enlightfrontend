package com.enlight.android.messaging

import android.app.NotificationManager
import android.content.Context
import androidx.core.app.NotificationCompat
import androidx.core.app.Person
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
        .setContentTitle(message.sender_id.toString())
        .setContentText(message.message)
        .addPerson(buildPerson(message))
        .setStyle(null)
        .setGroup(message.sender_id.toString())
        .setPriority(NotificationCompat.PRIORITY_HIGH)
        .build()

    private fun buildSummaryNotification(context: Context, message: Message) =
        NotificationCompat.Builder(context, "notifications")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(message.sender_id.toString())
            // Set content text to support devices running API level < 24.
            .setContentText(message.sender_id.toString())
            .addPerson(buildPerson(message))
            .setStyle(NotificationCompat.InboxStyle(buildInbox(context, message)))
            .setGroup(message.sender_id.toString())
            .setGroupSummary(true)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .build()

    private fun buildPerson(message: Message) =
        Person.Builder()
            .setName(message.sender_id.toString())
            .build()

    private fun buildInbox(context: Context, message: Message) =
        NotificationCompat.Builder(context, "notifications")
            .setContentTitle(message.sender_id.toString())
}
