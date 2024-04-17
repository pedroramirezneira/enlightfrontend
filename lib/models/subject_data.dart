class SubjectData {
  int id;
  String name;
  String description;
  int categoryId;
  String categoryName;

  SubjectData({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.categoryName,
  });

  factory SubjectData.fromJson(Map<String, dynamic> json) {
    return SubjectData(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      categoryId: json["category_id"],
      categoryName: json["category_name"],
    );
  }
}
