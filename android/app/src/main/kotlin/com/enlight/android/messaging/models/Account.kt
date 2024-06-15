package com.enlight.android.messaging.models

import com.google.gson.Gson
import io.ktor.client.HttpClient
import io.ktor.client.engine.cio.CIO
import io.ktor.client.request.get

data class Account(
    val id: Int,
    val email: String,
    val name: String,
    val birthday: String,
    val address: String
) {
    companion object {
        suspend fun getAccount() {
            val client = HttpClient(CIO)
            val response = client.get("https://movieweb.mediaversetv.com/account")
        }

        fun fromJson(json: String): Account {
            val gson = Gson()
            return gson.fromJson(json, Account::class.java)
        }
    }
}
