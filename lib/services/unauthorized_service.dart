import 'dart:convert';
import 'package:enlight/models/account/create_account_data.dart';
import 'package:enlight/util/web_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UnauthorizedService {
  const UnauthorizedService._();

  static Future<void> resetPassword(BuildContext context, String email) async {
    final serverAddress = dotenv.env["SERVER"]!;
    final response = await http.post(
      Uri.parse("$serverAddress/password-reset/request"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "email": email,
      }),
    );
    if (context.mounted) WebClient.info(response, context);
  }

  static Future<http.Response> register(
    BuildContext context,
    CreateAccountData data,
  ) async {
    final serverAddress = dotenv.env["SERVER"]!;
    final response = await http.post(
      Uri.parse("$serverAddress/account"),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(data.toJson()),
    );
    if (context.mounted) WebClient.info(response, context);
    return response;
  }
}
