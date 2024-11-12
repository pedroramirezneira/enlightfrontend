import 'package:enlight/macros/data_class.dart';
import 'package:json/json.dart';

@DataClass()
@JsonCodable()
class UpdateAccountData {
  final String name;
  final String birthday;
  final String address;
}
