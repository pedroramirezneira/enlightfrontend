import 'package:enlight/models/container_search_teacher_data.dart';
import 'package:enlight/models/subject_data.dart';

const List<ContainerSearchTeacherData> _teachers = [];
const List<SubjectData> _subjects = [];

class SearchData {
  final List<ContainerSearchTeacherData>? teachers;
  final List<SubjectData>? subjects;

  const SearchData({this.teachers, this.subjects});

  factory SearchData.fromJson(Map<String, dynamic> json) {
    return SearchData(
      teachers: (json['teachers'] as List)
          .map((e) => ContainerSearchTeacherData.fromJson(e))
          .toList(),
      subjects: (json['subjects'] as List)
          .map((e) => SubjectData.fromJson(e))
          .toList(),
    );
  }
}

class EmptySearchData extends SearchData {
  const EmptySearchData() : super(teachers: _teachers, subjects: _subjects);
}
