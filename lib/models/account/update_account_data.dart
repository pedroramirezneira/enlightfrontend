class UpdateAccountData {
  final String name;
  final String birthday;
  final String address;

  const UpdateAccountData({
    required this.name,
    required this.birthday,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthday': birthday,
      'address': address,
    };
  }
}
