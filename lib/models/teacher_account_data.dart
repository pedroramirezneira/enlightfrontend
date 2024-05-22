import 'package:enlight/models/account_data.dart';
import 'package:enlight/models/teacher_data.dart';

class TeacherAccountData extends AccountData {
  TeacherData teacher;

  TeacherAccountData({
    required super.id,
    required super.email,
    required super.name,
    required super.birthday,
    required super.address,
    required super.picture,
    required this.teacher,
  });

  factory TeacherAccountData.fromJson(Map<String, dynamic> json) {
    return TeacherAccountData(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      birthday: (json["birthday"] as String).split("T")[0],
      address: json["address"],
      picture: json["picture"],
      teacher: TeacherData.fromJson(json["teacher"]),
    );
  }
}
