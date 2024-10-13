import 'dart:convert';
import 'dart:typed_data';

import 'package:enlight/models/account/account_data.dart';

class ChatData implements AccountData {
  @override
  final int? id;

  @override
  final String email;

  @override
  String name;

  @override
  String birthday;

  @override
  String address;

  @override
  Uint8List? picture;

  int newMessages = 0;

  ChatData({
    required this.name,
    required this.address,
    required this.birthday,
    required this.picture,
    required this.id,
    required this.email,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    final picture = base64.decode(json["picture"] ?? "");
    return ChatData(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      birthday: (json["birthday"] as String).split("T")[0],
      address: json["address"],
      picture: picture,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "name": name,
      "birthday": birthday,
      "address": address,
      "picture": picture,
    };
  }
}
