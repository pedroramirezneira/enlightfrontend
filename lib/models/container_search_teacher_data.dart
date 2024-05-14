

class ConatinerSearchTeacherData {
  final int id;
  double rating;
  String name;
  String description;
  String? picture;

  ConatinerSearchTeacherData({
    required this.rating,
    required this.id,
    required this.name,
    required this.description,
    this.picture,
  });

  factory ConatinerSearchTeacherData.fromJson(Map<String, dynamic> json) {
    String? picture = json["picture"];
    return ConatinerSearchTeacherData(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      rating : 10.0,
      picture: picture ?? "",
    );
  }

}