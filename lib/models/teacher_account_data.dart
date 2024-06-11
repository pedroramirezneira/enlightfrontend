import 'dart:convert';

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
    final si = base64.decode(json["picture"] ?? "");
    return TeacherAccountData(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      birthday: (json["birthday"] as String).split("T")[0],
      address: json["address"],
      picture: si,
      teacher: TeacherData.fromJson(json["teacher"]),
    );
  }
}
// El sentarme a esperar
// Que los días pasen
// Y que quieras escuchar

// Siempre aquí te voy a esperar
// Voy a esperar