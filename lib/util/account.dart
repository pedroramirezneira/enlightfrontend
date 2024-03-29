import 'dart:convert';
import 'package:enlight/env.dart';
import 'package:enlight/util/token.dart';
import 'package:http/http.dart' as http;

class Account {
  static Future<int> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.http(server, "/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(
        {
          "email": email,
          "password": password,
        },
      ),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await Token.setAccessToken(data["access_token"]);
      await Token.setRefreshToken(data["refresh_token"]);
    }
    return response.statusCode;
  }

  static Future<bool> logout() async {
    final token = await Token.getRefreshToken();
    final response = await http.get(
      Uri.http(server, "/logout"),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      await Token.deleteRefreshToken();
      return true;
    }
    return false;
  }
}
