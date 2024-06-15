package com.enlight.android.messaging

import android.content.Context
import android.util.Log
import com.enlight.android.messaging.models.Message
import com.google.firebase.database.ChildEventListener
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class ChatListener(
    private val context: Context,
    private val scope: CoroutineScope,
    private val accountId: Int
) :
    ChildEventListener {
    private var initialized = false

    override fun onChildAdded(snapshot: DataSnapshot, previousChildName: String?) {
        if (!initialized) {
            scope.launch {
                delay(2000)
                initialized = true
            }
            return
        }
        val message = snapshot.getValue(Message::class.java) ?: return
        if (message.sender_id == accountId) return
        NotificationHandler.sendNotification(context, message)
    }

    override fun onChildChanged(snapshot: DataSnapshot, previousChildName: String?) {
        return
    }

    override fun onChildRemoved(snapshot: DataSnapshot) {
        return
    }

    override fun onChildMoved(snapshot: DataSnapshot, previousChildName: String?) {
        return
    }

    override fun onCancelled(error: DatabaseError) {
        Log.w("Enlight", "Failed to read value.", error.toException())
    }
}
