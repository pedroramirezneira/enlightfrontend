import 'package:enlight/env.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Token {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    return token;
  }

  static Future<bool> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setString("token", token);
    return saved;
  }

  static Future<bool> verifyToken(String token) async {
    final response = await http.get(
        Uri.http(
          server,
          "/verify",
        ),
        headers: {"Authorization": "Bearer $token"});
    return response.statusCode == 200;
  }
}
