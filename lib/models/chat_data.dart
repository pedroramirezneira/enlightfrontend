import 'package:enlight/models/account_data.dart';

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
  String? picture;

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
    return ChatData(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      birthday: (json["birthday"] as String).split("T")[0],
      address: json["address"],
      picture: json["picture"],
    );
  }
}
