import 'package:enlight/models/day_data.dart';
import 'package:enlight/models/subject_data.dart';

class SubjectTimeSlotData extends SubjectData {

  final String modality;
  final int size;

  SubjectTimeSlotData({
    required super.id,
    required super.categoryName,
    required super.name,
    required super.description,
    required super.price,
    required super.days,
    required this.modality,
    required this.size,
  });

  factory SubjectTimeSlotData.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? days = json["days"];
    return SubjectTimeSlotData(
      id: json["id"],
      categoryName: json["category_name"],
      name: json["name"],
      price: json["price"],
      description: json["description"],
      days: days != null
          ? days.map((day) => DayData.fromJson(day)).toList()
          : [],
      modality: json["modality"],
      size: json["size"],
    );
  }

}