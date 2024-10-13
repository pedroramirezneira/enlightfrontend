import 'dart:convert';
import 'dart:typed_data';

class AccountData {
  final int? id;
  final String email;
  String name;
  String birthday;
  String address;
  Uint8List? picture;

  AccountData({
    required this.id,
    required this.email,
    required this.name,
    required this.birthday,
    required this.address,
    this.picture,
  });

  factory AccountData.fromJson(Map<String, dynamic> json) {
    final picture = base64.decode(json["picture"] ?? "");
    return AccountData(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      birthday: (json["birthday"] as String).split("T")[0],
      address: json["address"],
      picture: picture,
    );
  }

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

  static AccountData empty() {
    return AccountData(
      id: null,
      email: "",
      name: "",
      birthday: "",
      address: "",
      picture: null,
    );
  }
}

class EmptyAccountData extends AccountData {
  EmptyAccountData()
      : super(
          id: null,
          email: "",
          name: "",
          birthday: "",
          address: "",
          picture: null,
        );
}
