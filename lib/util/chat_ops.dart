import 'dart:convert';

import 'package:enlight/models/chats_data.dart';
import 'package:enlight/util/token.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ChatOps {
  static Future<ChatsData> getChats() async {
    final token = await Token.getAccessToken();
    final response = await http.get(
      Uri.https(
        dotenv.env["SERVER"]!,
        "/chat",
      ),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode != 200) {
      throw response.statusCode;
    }
    final data = json.decode(response.body);
    return ChatsData.fromJson(data);
  }

  static Future<bool> createChat({required int receiverId}) async {
    final token = await Token.getAccessToken();
    final response = await http.post(
      Uri.https(
        dotenv.env["SERVER"]!,
        "/chat",
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: json.encode(
        {
          "receiver_id": receiverId,
        },
      ),
    );
    if (response.statusCode != 200) return false;
    return true;
  }
}
