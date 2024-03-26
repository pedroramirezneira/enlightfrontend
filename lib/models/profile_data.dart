import "dart:convert";
import "package:enlight/env.dart";
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
    return ProfileData(rating: 10, name: "Xoaco", zone: "si", tags:  ["Matematica"], description: "me gusta el LoL");
    /*
    final response = await http.get(Uri.http(
      server,
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