import 'package:enlight/models/container_search_teacher_data.dart';
import 'package:enlight/models/subject_data.dart';

class SearchData {
  final List<ContainerSearchTeacherData>? teacher;
  final List<SubjectData>? subject;

  SearchData({
    this.teacher,
    this.subject,
  });

  factory SearchData.fromJson(Map<String, dynamic> json) {
    List<dynamic>? subject = json["subjects"];
    List<dynamic>? teacher = json["teachers"];
    return SearchData(
      teacher: teacher != null
          ? teacher
              .map((teacher) => ContainerSearchTeacherData.fromJson(teacher))
              .toList()
          : [],
      subject: subject != null
          ? subject.map((subject) => SubjectData.fromJson(subject)).toList()
          : [],
    );
  }
}

class EmptySearchData extends SearchData {
  EmptySearchData() : super(teacher: [], subject: []);
}
