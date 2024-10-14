import 'package:enlight/models/subject_data.dart';
import 'package:enlight/models/teacher_data.dart';

class SearchTeacherData extends TeacherData {
  final String name;
  final String? picture;

  SearchTeacherData({
    required this.name,
    required super.description,
    required this.picture,
    required super.id,
    required super.rating,
    required super.subjects,
    required super.categories,
  });

  factory SearchTeacherData.fromJson(Map<String, dynamic> json) {
    final rating = json["rating"];
    final decoded = rating is double ? rating : (rating as int).toDouble();
    List<dynamic>? subjects = json["subjects"];
    return SearchTeacherData(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      picture: json["picture"],
      rating: decoded,
      subjects: subjects != null
          ? subjects.map((subject) => SubjectData.fromJson(subject)).toList()
          : [],
      categories: [],
    );
  }
}

class EmptySearchTeacherData extends SearchTeacherData {
  EmptySearchTeacherData()
      : super(
          id: -1,
          name: "",
          description: "",
          picture: "",
          rating: -1,
          subjects: [],
          categories: [],
        );
}
