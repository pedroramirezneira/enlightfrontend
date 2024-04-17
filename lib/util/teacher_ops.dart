import 'dart:convert';
import 'package:enlight/util/token.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TeacherOps {
  static Future<int> createSubject({
    required String categoryName,
    required String name,
    required String description,
  }) async {
    final token = await Token.getAccessToken();
    final response = await http.post(
      Uri.https(
        dotenv.env["SERVER"]!,
        "/subject",
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: json.encode({
        "category_name": categoryName,
        "name": name,
        "description": description,
      }),
    );
    return response.statusCode;
  }
}
