import 'dart:convert';
import 'package:enlight/models/account_data.dart';
import 'package:enlight/models/student_reservation_data.dart';
import 'package:enlight/util/io.dart';
import 'package:enlight/util/token.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AccountOps {
  static Future<int> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.https(
        dotenv.env["SERVER"]!,
        "/login",
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(
        {
          "email": email,
          "password": password,
        },
      ),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await Token.setAccessToken(data["access_token"]);
      await Token.setRefreshToken(data["refresh_token"]);
      await IO.setRole(data["role"]);
      return response.statusCode;
    }
    return response.statusCode;
  }

  static Future<bool> logout() async {
    final token = await Token.getRefreshToken();
    final response = await http.get(
      Uri.https(
        dotenv.env["SERVER"]!,
        "/logout",
      ),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      await Token.deleteRefreshToken();
      return true;
    }
    return false;
  }

  static Future<bool> delete() async {
    final token = await Token.getAccessToken();
    final response = await http.delete(
      Uri.https(
        dotenv.env["SERVER"]!,
        "/account",
      ),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      await Token.deleteRefreshToken();
      return true;
    }
    return false;
  }

  static Future<int> signUp({
    required String email,
    required String password,
    required String name,
    required String birthday,
    required String address,
    required String role,
  }) async {
    final response = await http.post(
      Uri.https(
        dotenv.env["SERVER"]!,
        "/account",
      ),
      headers: Map.from({"Content-Type": "application/json"}),
      body: json.encode(
        {
          "email": email,
          "password": password,
          "name": name,
          "birthday": birthday,
          "address": address,
          "role": role,
        },
      ),
    );
    return response.statusCode;
  }

  static Future<AccountData> getAccount() async {
    final token = await Token.getAccessToken();
    final response = await http.get(
      Uri.https(
        dotenv.env["SERVER"]!,
        "/account",
      ),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return AccountData.fromJson(data);
    }
    throw response.statusCode;
  }

  static Future<AccountData> getAccounWithPicture() async {
    final token = await Token.getAccessToken();
    final response = await http.get(
      Uri.https(
        dotenv.env["SERVER"]!,
        "/account",
        {
          "include_picture": "true",
        },
      ),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return AccountData.fromJson(data);
    }
    throw response.statusCode;
  }

  static Future<int> updateAccount({
    required String name,
    required String birthday,
    required String address,
  }) async {
    final token = await Token.getAccessToken();
    final response = await http.put(
      Uri.https(
        dotenv.env["SERVER"]!,
        "/account",
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: json.encode(
        {
          "name": name,
          "birthday": birthday,
          "address": address,
        },
      ),
    );
    return response.statusCode;
  }

  static Future<int> insertPicture({required String picture}) async {
    final token = await Token.getAccessToken();
    final response = await http.put(
      Uri.https(
        dotenv.env["SERVER"]!,
        "account/picture",
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: json.encode(
        {
          "picture": picture,
        },
      ),
    );
    return response.statusCode;
  }

  static Future<int> requestPasswordReset({required String email}) async {
    final response = await http.post(
      Uri.https(
        dotenv.env["SERVER"]!,
        "/password-reset/request",
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(
        {
          "email": email,
        },
      ),
    );
    return response.statusCode;
  }

  static Future<List<StudentReservationData>> getReservation() async {
    final token = await Token.getAccessToken();
    final response = await http.get(
      Uri.https(
        dotenv.env["SERVER"]!,
        "/reservation",
      ),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => StudentReservationData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reservations');
    }
  }

  static Future<bool> cancelReservation(int id) async {
    final token = await Token.getAccessToken();
    final response = await http.delete(
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
          "id": id,
        },
      ),
    );
    return response.statusCode == 200;
  }
}
