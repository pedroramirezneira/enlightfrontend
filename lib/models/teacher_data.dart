import 'package:enlight/models/account_data.dart';

class TeacherData extends AccountData {
  double rating;
  List<String> tags;
  String description;

  TeacherData({
    required this.rating,
    required this.tags,
    required this.description,
    required super.picture, 
    required super.email, 
    required super.birthday, 
    required super.address, 
    required super.name,
  });

  factory TeacherData.fromJson(Map<String, dynamic> json) {
    return TeacherData(
      rating: json["rating"],
      description: json["teacher"]["description"],
      name: json["name"],
      address: json["address"],
      tags: json["tags"],
      picture: json["picture"], 
      email: json["email"],
      birthday: (json["birthday"] as String).split("T")[0],
    );
  }
}
