import 'dart:convert';

import 'package:enlight/macros/data_class.dart';
import 'package:enlight/models/account/account_data.dart';
import 'package:json/json.dart';

@DataClass()
@JsonCodable()
class AccountDataDto {
  final int? id;
  final String email;
  final String name;
  final String birthday;
  final String address;
  final String? picture;

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
