package com.enlight.android.messaging.models

import androidx.annotation.Keep

@Keep
data class Message(
    val sender_id: Int = -1,
    val message: String = "",
    val timestamp: String = ""
)
