import 'package:enlight/models/day_data.dart';

class SubjectData {
  final int id;
  String categoryName;
  String name;
  String description;
  int price;
  List<DayData> days;

  SubjectData({
    required this.id,
    required this.categoryName,
    required this.name,
    required this.description,
    required this.price,
    required this.days,
  });

  factory SubjectData.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? days = json["days"];
    return SubjectData(
      id: json["id"],
      categoryName: json["category_name"],
      name: json["name"],
      price: json["price"],
      description: json["description"],
      days:
          days != null ? days.map((day) => DayData.fromJson(day)).toList() : [],
    );
  }
}
