package com.enlight.android.messaging

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_REMOTE_MESSAGING
import android.os.Build
import android.os.IBinder
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import com.enlight.android.R
import com.google.firebase.Firebase
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.database
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import java.util.ArrayList

class NotificationService : Service() {
    private val serviceScope = CoroutineScope(SupervisorJob() + Dispatchers.Main)
    private val listeners: MutableMap<DatabaseReference, ChatListener> = mutableMapOf()

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    @RequiresApi(Build.VERSION_CODES.UPSIDE_DOWN_CAKE)
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent == null) return START_NOT_STICKY
        val manager = this.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        ensureNotificationChannelExists(manager)
        val accountId = intent.getIntExtra("accountId", -1)
        val receiverIds = intent.getIntegerArrayListExtra("receiverIds")!!
        val database = Firebase.database
        val chats = database.getReference("chat")
        registerListeners(receiverIds, accountId, chats)
        val notification = getServiceNotification()
        startService(notification)
        return START_REDELIVER_INTENT
    }

    override fun onDestroy() {
        serviceScope.cancel()
        deleteListeners()
    }

    private fun registerListeners(
        receiverIds: ArrayList<Int>,
        accountId: Int,
        chats: DatabaseReference
    ) {
        receiverIds.forEach { receiverId ->
            val list = listOf(accountId, receiverId).sorted()
            val chatKey = list.joinToString("-")
            val chat = chats.child(chatKey)
            val listener = ChatListener(this, serviceScope, accountId)
            chat.addChildEventListener(listener)
            listeners[chat] = listener
        }
    }

    private fun deleteListeners() {
        listeners.forEach { entry ->
            entry.key.removeEventListener(entry.value)
        }
        listeners.clear()
    }

    private fun getServiceNotification(): Notification =
        NotificationCompat.Builder(this, "notifications")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setOngoing(false)
            .build()

    private fun startService(notification: Notification) {
        val usesType = Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE
        when {
            usesType -> startForeground(
                START_REDELIVER_INTENT,
                notification,
                FOREGROUND_SERVICE_TYPE_REMOTE_MESSAGING
            )

            else -> startForeground(START_REDELIVER_INTENT, notification)
        }
    }

    companion object {
        fun ensureNotificationChannelExists(manager: NotificationManager) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val channel = NotificationChannel(
                    "notifications", "Notifications", NotificationManager.IMPORTANCE_DEFAULT
                )
                manager.createNotificationChannel(channel)
            }
        }
    }
}
