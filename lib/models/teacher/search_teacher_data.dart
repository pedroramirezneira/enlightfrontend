import 'package:enlight/macros/data_class.dart';
import 'package:enlight/models/category_data.dart';
import 'package:enlight/models/subject_data.dart';
import 'package:json/json.dart';

@DataClass()
@JsonCodable()
class SearchTeacherData {
  final int id;
  String description;
  double rating;
  List<SubjectData> subjects;
  List<CategoryData> categories;
  final String name;
  final String? picture;
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
