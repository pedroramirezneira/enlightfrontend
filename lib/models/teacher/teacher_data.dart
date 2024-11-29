import 'package:enlight/macros/data_class.dart';
import 'package:enlight/models/category_data.dart';
import 'package:enlight/models/subject_data.dart';
import 'package:json/json.dart';

@DataClass()
@JsonCodable()
class TeacherData {
  final int id;
  String description;
  double rating;
  List<SubjectData> subjects;
  List<CategoryData> categories;
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
