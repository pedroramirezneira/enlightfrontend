import 'dart:convert';
import 'package:enlight/models/teacher/search_teacher_data.dart';
import 'package:enlight/models/subject_data.dart';
import 'package:enlight/models/teacher/teacher_data.dart';
import 'package:enlight/util/web_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TeacherService extends ChangeNotifier {
  TeacherData _data = EmptyTeacherData();
  TeacherData get data => _data;
  var _loading = true;
  bool get loading => _loading;

  TeacherService({required BuildContext context}) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final response = await WebClient.get(
        context,
        "teacher",
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        _data = TeacherData.fromJson(data);
      }
      _loading = false;
      notifyListeners();
    });
  }

  Future<http.Response> updateTeacher(
      BuildContext context, String description) async {
    final response = await WebClient.put(
      context,
      "teacher",
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "description": description,
      }),
    );
    if (response.statusCode == 200) {
      _data.description = description;
      notifyListeners();
    }
    return response;
  }

  Future<http.Response> createSubject({
    required BuildContext context,
    required SubjectData data,
    required String modality,
    required int size,
  }) async {
    final response = await WebClient.post(
      context,
      "subject",
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "category_name": data.categoryName,
        "name": data.name,
        "price": data.price,
        "description": data.description,
        "days": data.days.map((day) => day.toJson()).toList(),
        "modality": modality,
        "size": size,
      }),
    );
    if (response.statusCode == 200) {
      _data.subjects.add(data);
      notifyListeners();
    }
    return response;
  }

  Future<void> deleteSubject(BuildContext context, int id) async {
    final response = await WebClient.delete(
      context,
      "subject",
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "id": "$id",
      }),
    );
    if (response.statusCode == 200) {
      _data.subjects.removeWhere((subject) => subject.id == id);
      notifyListeners();
    }
  }

  static Future<SearchTeacherData> getTeacherFromSearch(
    BuildContext context,
    int id,
  ) async {
    final response = await WebClient.get(
      context,
      "teacher/$id",
      info: false,
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return SearchTeacherData.fromJson(data);
    }
    return EmptySearchTeacherData();
  }
}
