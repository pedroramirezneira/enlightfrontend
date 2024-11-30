class ContainerSearchTeacherData {
  final int id;
  double rating;
  String name;
  String description;
  String? picture;

  ContainerSearchTeacherData({
    required this.rating,
    required this.id,
    required this.name,
    required this.description,
    this.picture,
  });

  factory ContainerSearchTeacherData.fromJson(Map<String, dynamic> json) {
    return ContainerSearchTeacherData(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      picture: json['picture'],
      rating: json['rating'],
    );
  }
}
