import 'dart:typed_data';
import 'package:enlight/macros/data_class.dart';

@DataClass()
class AccountData {
  final int? id;
  final String email;
  String name;
  String birthday;
  String address;
  Uint8List? picture;
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
