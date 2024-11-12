import 'package:enlight/macros/data_class.dart';
import 'package:json/json.dart';

@DataClass()
@JsonCodable()
class CreateAccountData {
  final String email;
  final String password;
  final String name;
  final String birthday;
  final String address;
  final String role;
}
