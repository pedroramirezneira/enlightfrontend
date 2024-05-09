class SearchTeacherData {
  final int id;
  int accountId;
  String name;
  String description;
  String? picture;

  SearchTeacherData({
    required this.id,
    required this.accountId,
    required this.name,
    required this.description,
    this.picture,
  });

  factory SearchTeacherData.fromJson(Map<String, dynamic> json) {
    String? picture = json["picture"];
    return SearchTeacherData(
      accountId: json["account_id"],
      id: json["id"],
      name: json["name"],
      description: json["description"],
      picture: picture ?? "",
    );
  }

}