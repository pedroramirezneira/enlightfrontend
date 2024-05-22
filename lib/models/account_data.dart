class AccountData {
  final int? id;
  final String email;
  String name;
  String birthday;
  String address;
  String? picture;

  AccountData({
    required this.id,
    required this.email,
    required this.name,
    required this.birthday,
    required this.address,
    this.picture,
  });

  factory AccountData.fromJson(Map<String, dynamic> json) {
    return AccountData(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      birthday: (json["birthday"] as String).split("T")[0],
      address: json["address"],
      picture: json["picture"],
    );
  }
}
