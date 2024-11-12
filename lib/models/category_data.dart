import 'package:json/json.dart';

@JsonCodable()
class CategoryData {
  String name;

  CategoryData({
    required this.name,
  });
}
