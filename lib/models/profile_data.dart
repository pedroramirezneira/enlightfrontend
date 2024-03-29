import "dart:convert";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:http/http.dart" as http;

class ProfileData {
  final double rating;
  String name;
  String zone;
  List<String> tags;
  String description;


  ProfileData({
    required this.rating,
    required this.name,
    required this.zone,
    required this.tags,
    required this.description
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      rating: json["rating"],
      description: json["description"],
      name: json["name"],
      zone: json["zone"],
      tags: json["tags"]
    );
  }

  static Future<ProfileData> getProfiles() async {
    return ProfileData(rating: 10, name: "Xoaco", zone: "si", tags:  ["Matematica", "Literatura", "Arte", "Prog", "Ingles", "PedroTv", "Lengua", "Etica", "Historia"], description: "Un profesor es un guía en el aprendizaje, inspirando, enseñando y formando a los estudiantes para un futuro prometedor.");
    /*
    final response = await http.get(Uri.https(
      dotenv.env["SERVER"]!,
      "/account",
      {"token":"Token"}
    ));
    if (response.reasonPhrase != "OK") {
      throw Exception(response.body);
    }
    final dynamic profile = json.decode(response.body);
    return ProfileData.fromJson(profile);
  }
  */
  }
}