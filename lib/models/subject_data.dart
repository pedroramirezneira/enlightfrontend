// ignore_for_file: non_constant_identifier_names

import 'package:enlight/models/day_data.dart';

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

  factory SubjectData.fromJson(Map<String, dynamic> json) {
    return SubjectData(
      id: json['id'],
      category_name: json['category_name'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      days: (json['days'] as List)
          .map<DayData>((day) => DayData.fromJson(day))
          .toList(),
    );
  }
}

class EmptySubjectData extends SubjectData {
  EmptySubjectData()
      : super(
          id: -1,
          category_name: "",
          name: "",
          description: "",
          price: 0,
          days: [],
        );
}
