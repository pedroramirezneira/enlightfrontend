import 'package:enlight/macros/data_class.dart';
import 'package:json/json.dart';

@DataClass()
@JsonCodable()
class CategoryData {
  final String name;
}
