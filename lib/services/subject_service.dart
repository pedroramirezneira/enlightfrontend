import 'dart:convert';

import 'package:enlight/models/subject_data.dart';
import 'package:enlight/models/subject_timeslot.dart';
import 'package:enlight/util/web_client.dart';
import 'package:flutter/material.dart';

class SubjectService {
  static Future<SubjectTimeSlotData> getSubjectWithTimeslot(
    BuildContext context,
    int id,
  ) async {
    final response = await WebClient.get(
      context,
      "subject/$id?include_timeslot=true",
      info: false,
    );
    if (response.statusCode != 200) {
      throw response.statusCode;
    }
    final data = json.decode(response.body);
    return SubjectTimeSlotData.fromJson(data);
  }

  static Future<SubjectData> getSubject(BuildContext context, int id) async {
    final response = await WebClient.get(
      context,
      "subject/$id",
    );
    if (response.statusCode != 200) {
      throw response.statusCode;
    }
    final data = json.decode(response.body);
    return SubjectData.fromJson(data);
  }
}
