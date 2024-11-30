import 'package:enlight/models/category_data.dart';
import 'package:enlight/models/subject_data.dart';
class TeacherData {
  final int id;
  String description;
  num rating;
  List<SubjectData> subjects;
  List<CategoryData> categories;

  TeacherData({
    required this.id,
    required this.description,
    required this.rating,
    required this.subjects,
    required this.categories,
  });

  factory TeacherData.fromJson(Map<String, dynamic> json) {
    return TeacherData(
      id: json['id'],
      description: json['description'],
      rating: json['rating'],
      subjects: (json['subjects'] as List)
          .map((e) => SubjectData.fromJson(e))
          .toList(),
      categories: (json['categories'] as List)
          .map((e) => CategoryData.fromJson(e))
          .toList(),
    );
  }
}

class EmptyTeacherData extends TeacherData {
  EmptyTeacherData()
      : super(
          id: -1,
          description: "",
          rating: -1.0,
          subjects: [],
          categories: [],
        );
}
