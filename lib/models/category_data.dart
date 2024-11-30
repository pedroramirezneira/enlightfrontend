class CategoryData {
  final String name;

  CategoryData({
    required this.name,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      name: json['name'],
    );
  }
}
