import 'package:enlight/models/account_data.dart';
import 'package:enlight/models/teacher_data.dart';

class TeacherAccountData extends AccountData {
  TeacherData teacher;

  TeacherAccountData({
    required super.email,
    required super.name,
    required super.birthday,
    required super.address,
    required this.teacher,
  });

  factory TeacherAccountData.fromJson(Map<String, dynamic> json) {
    return TeacherAccountData(
      email: json["email"],
      name: json["name"],
      birthday: (json["birthday"] as String).split("T")[0],
      address: json["address"],
      teacher: TeacherData.fromJson(
        json["teacher"],
      ),
    );
  }
}
