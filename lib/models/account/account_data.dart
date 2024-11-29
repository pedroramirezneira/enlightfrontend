import 'dart:typed_data';
import 'package:enlight/macros/data_class.dart';

@DataClass()
class AccountData {
  final int? id;
  final String email;
  final String name;
  final String birthday;
  final String address;
  final Uint8List? picture;
}

class EmptyAccountData extends AccountData {
  const EmptyAccountData()
      : super(
          id: null,
          email: "",
          name: "",
          birthday: "",
          address: "",
          picture: null,
        );
}
