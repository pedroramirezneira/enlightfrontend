import 'dart:convert';
import 'package:enlight/models/day_data.dart';
import 'package:enlight/models/searched_teacher_data.dart';
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

  static Future<http.Response> createSubject({
    required String categoryName,
    required String name,
    required String description,
    required int price,
    required int group,
    required String modality,
    required List<DayData> days,
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
        "price": price,
        "description": description,
        "days": days.map((day) => day.toJson()).toList(),
        "modality": modality,
        "size": group,
      }),
    );
    return response;
  }

  static Future<bool> deleteSubject({
    required int id,
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
      body: json.encode(
        {
          "id": id,
        },
      ),
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
      return TeacherAccountData.fromJson(data);
    }
    throw response.statusCode;
  }

  static Future<SearchTeacherData> getTeacherFromSearch(int id) async {
    final token = await Token.getAccessToken();
    final response = await http.get(
      Uri.https(
        dotenv.env["SERVER"]!,
        "/teacher",
        {
          "id": "$id",
        },
      ),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return SearchTeacherData.fromJson(data);
    }
    throw response.statusCode;
  }
}
