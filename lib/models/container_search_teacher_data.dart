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
    double rating = 0.0;
    if (json["rating"] != null) {
      try {
        rating = double.parse(json["rating"].toString());
      } catch (e) {
        print("Error parsing rating: $e");
      }
    }
    return ConatinerSearchTeacherData(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      rating: rating,
      picture: picture ?? "",
    );
  }
}
