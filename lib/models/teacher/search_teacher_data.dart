import 'dart:convert';
import 'dart:typed_data';
import 'package:enlight/models/subject_data.dart';
import 'package:enlight/models/teacher/teacher_data.dart';

class SearchTeacherData extends TeacherData {
  final String name;
  final Uint8List? picture;

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
    final picture = json["picture"];
    final decodedPicture = picture is String ? base64.decode(picture) : null;
    List<dynamic>? subjects = json["subjects"];
    return SearchTeacherData(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      picture: decodedPicture,
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
          picture: null,
          rating: -1,
          subjects: [],
          categories: [],
        );
}
