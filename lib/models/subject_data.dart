import 'package:json/json.dart';
import 'package:enlight/models/day_data.dart';

@JsonCodable()
class SubjectData {
  final int id;
  String category_name;
  String name;
  String description;
  int price;
  List<DayData> days;

  SubjectData({
    required this.id,
    required this.category_name,
    required this.name,
    required this.description,
    required this.price,
    required this.days,
  });
}
