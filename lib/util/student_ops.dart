import 'dart:convert';

import 'package:enlight/util/token.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class StudentOps {
  static Future<bool> reserveTimeslot(
    int timeslotId,
    String date,
    String modality,
  ) async {
    final token = await Token.getAccessToken();
    final response = await http.post(
      Uri.https(
        dotenv.env["SERVER"]!,
        "/reservation",
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: json.encode(
        {
          "timeslot_id": timeslotId,
          "date": date,
          "modality": modality,
        },
      ),
    );
    if (response.statusCode != 200) return false;
    return true;
  }

  static Future<bool> completeReservation(int reservationID) async {
    final token = await Token.getAccessToken();
    final response = await http.get(
      Uri.https(dotenv.env["SERVER"]!, "/rating", {
        "reservation_id": "$reservationID",
      }),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode != 200) return false;
    return true;
  }

  static Future<bool> rateTeacher(
      int reservationID, int teacherID, double rating) async {
    final token = await Token.getAccessToken();
    final response = await http.put(
      Uri.https(
        dotenv.env["SERVER"]!,
        "/rating",
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: json.encode(
        {
          "reservation_id": reservationID,
          "teacher_id": teacherID,
          "rating": rating,
        },
      ),
    );
    if (response.statusCode != 200) return false;
    return true;
  }
}
