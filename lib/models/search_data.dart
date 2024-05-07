import 'package:enlight/models/search_teacher_data.dart';
import 'package:enlight/models/subject_data.dart';

class SearchData {
  final List<SearchTeacherData>? teacher; 
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
          ? teacher.map((teacher) => SearchTeacherData.fromJson(teacher)).toList()
          : [],
      subject: subject != null
          ? subject.map((subject) => SubjectData.fromJson(subject)).toList()
          : [],
    );
  }
}
