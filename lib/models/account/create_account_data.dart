class CreateAccountData {
  final String email;
  final String password;
  final String name;
  final String birthday;
  final String address;
  final String role;

  const CreateAccountData({
    required this.email,
    required this.password,
    required this.name,
    required this.birthday,
    required this.address,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'birthday': birthday,
      'address': address,
      'role': role,
    };
  }
}
