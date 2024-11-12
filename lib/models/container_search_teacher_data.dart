import 'package:json/json.dart';

@JsonCodable()
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
}
