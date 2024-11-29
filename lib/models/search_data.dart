import 'package:enlight/macros/data_class.dart';
import 'package:enlight/models/container_search_teacher_data.dart';
import 'package:enlight/models/subject_data.dart';
import 'package:json/json.dart';

const List<ContainerSearchTeacherData> _teachers = [];
const List<SubjectData> _subjects = [];

@DataClass()
@JsonCodable()
class SearchData {
  final List<ContainerSearchTeacherData>? teachers;
  final List<SubjectData>? subjects;
}

class EmptySearchData extends SearchData {
  const EmptySearchData() : super(teachers: _teachers, subjects: _subjects);
}
