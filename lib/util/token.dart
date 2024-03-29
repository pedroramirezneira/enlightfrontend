import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Token {
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token");
    return token;
  }

  static Future<bool> setAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setString("access_token", token);
    return saved;
  }

  static Future<bool> verifyAccessToken(String token) async {
    final response = await http.get(
        Uri.https(
          dotenv.env["SERVER"]!,
          "/verify",
        ),
        headers: {"Authorization": "Bearer $token"});
    return response.statusCode == 200;
  }

  static Future<String?> getRefreshToken() async {
    const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );
    final token = await storage.read(key: "refresh_token");
    return token;
  }

  static Future<void> setRefreshToken(String token) async {
    const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );
    await storage.write(key: "refresh_token", value: token);
  }

  static Future<void> deleteRefreshToken() async {
    const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );
    await storage.delete(key: "refresh_token");
  }

  static Future<void> refreshAccessToken() async {
    final token = await getRefreshToken();
    if (token == null) {
      return;
    }
    http
        .post(
      Uri.https(
        dotenv.env["SERVER"]!,
        "/refresh",
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "refresh_token": token,
      }),
    )
        .then((response) {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Token.setAccessToken(data["access_token"]);
      }
    });
  }
}
