import 'package:enlight/models/category_data.dart';
import 'package:enlight/models/subject_data.dart';
class SearchTeacherData {
  final int id;
  String description;
  double rating;
  List<SubjectData> subjects;
  List<CategoryData> categories;
  final String name;
  final String? picture;

  SearchTeacherData({
    required this.id,
    required this.name,
    required this.description,
    required this.picture,
    required this.rating,
    required this.subjects,
    required this.categories,
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
      categories: (json['categories'] as List)
          .map((e) => CategoryData.fromJson(e))
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
          categories: [],
        );
}
