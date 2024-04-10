import 'package:shared_preferences/shared_preferences.dart';

class IO {
  static Future<bool> setRole(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setString("role", id == 1 ? "student" : "teacher");
    return saved;
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("role");
    return token;
  }
}