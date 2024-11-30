// ignore_for_file: non_constant_identifier_names

import 'package:enlight/models/day_data.dart';

class SubjectTimeSlotData {
  final int teacher_id;
  final String modality;
  final int size;
  final int id;
  String category_name;
  String name;
  String description;
  int price;
  List<DayData> days;

  SubjectTimeSlotData({
    required this.id,
    required this.category_name,
    required this.name,
    required this.description,
    required this.price,
    required this.days,
    required this.teacher_id,
    required this.modality,
    required this.size,
  });

  factory SubjectTimeSlotData.fromJson(Map<String, dynamic> json) {
    return SubjectTimeSlotData(
      id: json['id'],
      category_name: json['category_name'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      days: (json['days'] as List)
          .map<DayData>((day) => DayData.fromJson(day))
          .toList(),
      teacher_id: json['teacher_id'],
      modality: json['modality'],
      size: json['size'],
    );
  }
}

class EmptySubjectTimeSlotData extends SubjectTimeSlotData {
  EmptySubjectTimeSlotData()
      : super(
          id: -1,
          category_name: "",
          name: "",
          description: "",
          price: 0,
          days: [],
          teacher_id: -1,
          modality: "",
          size: -1,
        );
}
