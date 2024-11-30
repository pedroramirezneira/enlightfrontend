import 'dart:convert';

import 'package:enlight/models/account/account_data.dart';
class AccountDataDto {
  final int? id;
  final String email;
  final String name;
  final String birthday;
  final String address;
  final String? picture;

  const AccountDataDto({
    this.id,
    required this.email,
    required this.name,
    required this.birthday,
    required this.address,
    this.picture,
  });

  factory AccountDataDto.fromJson(Map<String, dynamic> json) {
    return AccountDataDto(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      birthday: json['birthday'],
      address: json['address'],
      picture: json['picture'],
    );
  }

  AccountData toData() {
    final bytes = picture != null ? base64.decode(picture!) : null;
    return AccountData(
      id: id,
      email: email,
      name: name,
      birthday: birthday,
      address: address,
      picture: bytes,
    );
  }
}
