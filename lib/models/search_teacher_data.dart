class SearchTeacherData {
  final int id;
  String name;
  String description;
  String? picture;

  SearchTeacherData({
    required this.id,
    required this.name,
    required this.description,
    this.picture,
  });

  factory SearchTeacherData.fromJson(Map<String, dynamic> json) {
    String? picture = json["picture"];
    return SearchTeacherData(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      picture: picture ?? "",
    );
  }

}