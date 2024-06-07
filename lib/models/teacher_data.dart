import 'package:enlight/models/category_data.dart';
import 'package:enlight/models/subject_data.dart';

class TeacherData {
  String description;
  double rating;
  List<SubjectData> subjects;
  List<CategoryData> categories;

  TeacherData({
    required this.description,
    required this.rating,
    required this.subjects,
    required this.categories,
  });

  factory TeacherData.fromJson(Map<String, dynamic> json) {
    List<dynamic>? subjects = json["subjects"];
    List<dynamic>? categories = json["categories"];
    final rating = json["rating"].toString();
    return TeacherData(
      description: json["description"],
      rating: double.tryParse(rating) ?? 0.0,
      subjects: subjects != null
          ? subjects.map((subject) => SubjectData.fromJson(subject)).toList()
          : [],
      categories: categories != null
          ? categories
              .map((category) => CategoryData.fromJson(category))
              .toList()
          : [],
    );
  }
}
