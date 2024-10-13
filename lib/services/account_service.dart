import 'dart:convert';
import 'package:enlight/models/account/account_data.dart';
import 'package:enlight/models/account/update_account_data.dart';
import 'package:enlight/services/auth_service.dart';
import 'package:enlight/util/web_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class AccountService extends ChangeNotifier {
  AccountData _data = EmptyAccountData();
  AccountData get data => _data;

  AccountService({required BuildContext context}) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final response = await WebClient.get(
        context,
        "account?include_picture=true",
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        _data = AccountData.fromJson(data);
        notifyListeners();
      }
    });
  }

  Future<http.Response> updateAccount(
    BuildContext context,
    UpdateAccountData newData,
  ) async {
    notifyListeners();
    final response = await WebClient.put(
      context,
      "account",
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(newData.toJson()),
    );
    if (response.statusCode == 200) {
      _data.name = newData.name;
      _data.birthday = newData.birthday;
      _data.address = newData.address;
      notifyListeners();
    }
    return response;
  }

  static Future<void> deleteAccount(BuildContext context) async {
    final authService = AuthService.of(context);
    final response = await WebClient.delete(context, "account");
    if (response.statusCode == 200) {
      await authService.logout();
    }
  }

  Future<void> insertPicture(BuildContext context, Uint8List bytes) async {
    final encoded = base64.encode(bytes);
    final response = await WebClient.put(
      context,
      "account/picture",
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(
        {
          "picture": encoded,
        },
      ),
    );
    if (response.statusCode == 200) {
      _data.picture = bytes;
      notifyListeners();
    }
  }
}
