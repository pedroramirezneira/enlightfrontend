class TeacherProfileData {
  double rating;
  String name;
  String zone;
  List<String> tags;
  String description;
  String picture;

  TeacherProfileData({
    required this.rating,
    required this.name,
    required this.zone,
    required this.tags,
    required this.description,
    required this.picture,
  });

  factory TeacherProfileData.fromJson(Map<String, dynamic> json) {
    return TeacherProfileData(
      rating: json["rating"],
      description: json["description"],
      name: json["name"],
      zone: json["address"],
      tags: json["tags"],
      picture: json["picture"],
    );
  }
}
