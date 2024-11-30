import 'package:enlight/models/subject_data.dart';

class SearchTeacherData {
  final int id;
  String description;
  num rating;
  List<SubjectData> subjects;
  final String name;
  final String? picture;

  SearchTeacherData({
    required this.id,
    required this.name,
    required this.description,
    required this.picture,
    required this.rating,
    required this.subjects,
  });

  factory SearchTeacherData.fromJson(Map<String, dynamic> json) {
    return SearchTeacherData(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      picture: json['picture'],
      rating: json['rating'],
      subjects: (json['subjects'] as List)
          .map((e) => SubjectData.fromJson(e))
          .toList(),
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
        );
}
