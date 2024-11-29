// ignore_for_file: non_constant_identifier_names

import 'package:enlight/models/day_data.dart';
import 'package:enlight/models/subject_data.dart';

class SubjectTimeSlotData extends SubjectData {
  final int teacherId;
  final String modality;
  final int size;

  SubjectTimeSlotData({
    required super.id,
    required super.category_name,
    required super.name,
    required super.description,
    required super.price,
    required super.days,
    required this.teacherId,
    required this.modality,
    required this.size,
  });

  factory SubjectTimeSlotData.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? days = json["days"];
    return SubjectTimeSlotData(
      id: json["id"],
      category_name: json["category_name"],
      name: json["name"],
      price: json["price"],
      description: json["description"],
      days:
          days != null ? days.map((day) => DayData.fromJson(day)).toList() : [],
      teacherId: json["teacher_id"],
      modality: json["modality"],
      size: json["size"],
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
          teacherId: -1,
          modality: "",
          size: -1,
        );
}
