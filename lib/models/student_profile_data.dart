import 'dart:convert';

class StudentProfileData {
  String name;
  String zone;
  String picture;


  StudentProfileData({
    required this.name,
    required this.zone,
    required this.picture
  });

  factory StudentProfileData.fromJson(Map<String, dynamic> json) {
    List<int> codeUnits = json["profile_picture"]["data"].cast<int>();
    String url = utf8.decode(codeUnits);
    return StudentProfileData(
      name: json["name"],
      zone: json["address"],
      picture: url
    );
  }
  
}