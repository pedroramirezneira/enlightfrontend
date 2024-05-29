import 'dart:convert';

import 'package:enlight/models/subject_data.dart';
import 'package:enlight/models/subject_timeslot.dart';
import 'package:enlight/util/token.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SubjectOps {
  static Future<SubjectTimeSlotData> getSubjectWithTimeslot(int id) async {
    final token = await Token.getAccessToken();
    final response = await http.get(
      Uri.http(
        dotenv.env["SERVER"]!,
        "/subject/$id",
        {
          "include_timeslot": 'true',
        },
      ),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode != 200) {
      throw response.statusCode;
    }
    final data = json.decode(response.body);
    return SubjectTimeSlotData.fromJson(data);
}

static Future<SubjectData> getSubject(int id) async {
    final token = await Token.getAccessToken();
    final response = await http.get(
      Uri.http(
        dotenv.env["SERVER"]!,
        "/subject/$id",
      ),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode != 200) {
      throw response.statusCode;
    }
    final data = json.decode(response.body);
    return SubjectData.fromJson(data);
}

}
