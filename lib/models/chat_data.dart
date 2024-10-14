import 'dart:convert';

import 'package:enlight/models/account/account_data.dart';

class ChatData extends AccountData {
  int newMessages = 0;

  ChatData({
    required super.id,
    required super.email,
    required super.name,
    required super.birthday,
    required super.address,
    required super.picture,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    final picture = json["picture"];
    final decoded = picture is String ? base64.decode(picture) : null;
    return ChatData(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      birthday: json["birthday"],
      address: json["address"],
      picture: decoded,
    );
  }
}
