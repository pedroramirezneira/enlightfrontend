class SubjectData {
  int id;
  String name;
  String description;
  int categoryId;
  int price;
  String categoryName;

  SubjectData({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.price,
  });

  factory SubjectData.fromJson(Map<String, dynamic> json) {
    return SubjectData(
      id: json["id"],
      name: json["name"],
      price: json["price"],
      description: json["description"],
      categoryId: json["category_id"],
      categoryName: json["category_name"],
    );
  }
}
