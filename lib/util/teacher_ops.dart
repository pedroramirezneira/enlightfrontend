import 'dart:convert';
import 'package:enlight/models/teacher_account_data.dart';
import 'package:enlight/util/token.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TeacherOps {
  static Future<int> updateTeacher({
    required String description,
  }) async {
    final token = await Token.getAccessToken();
    final response = await http.put(
      Uri.https(
        dotenv.env["SERVER"]!,
        "/teacher",
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: json.encode({
        "description": description,
      }),
    );
    return response.statusCode;
  }

  static Future<int> createSubject({
    required String categoryName,
    required String name,
    required int price,
    required String description,
    required List<String> days,
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
        "days": days,
        "name": name,
        "price": price,
        "description": description,
      }),
    );
    return response.statusCode;
  }

  static Future<bool> deleteSubject({
    required int subjectID,
  }) async {
    final token = await Token.getAccessToken();
    final response = await http.delete(
      Uri.https(
        dotenv.env["SERVER"]!,
        "/subject",
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: json.encode({
        "subject_id": subjectID,
      }),
    );
    return response.statusCode == 200;
  }

  static Future<TeacherAccountData> getTeacher() async {
    final token = await Token.getAccessToken();
    final response = await http.get(
      Uri.https(
        dotenv.env["SERVER"]!,
        "/account",
        {
          "include_picture": "true",
        },
      ),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      data["teacher"]["rating"] = 10.0;
      return TeacherAccountData.fromJson(data);
    }
    throw response.statusCode;
  }
}
