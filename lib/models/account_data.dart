class AccountData {
  final String email;
  String name;
  final String birthday;
  final String address;

  AccountData({
    required this.email,
    required this.name,
    required this.birthday,
    required this.address,
  });

  factory AccountData.fromJson(Map<String, dynamic> json) {
    return AccountData(
      email: json["email"],
      name: json["name"],
      birthday: (json["birthday"] as String).split("T")[0],
      address: json["address"],
    );
  }
}
