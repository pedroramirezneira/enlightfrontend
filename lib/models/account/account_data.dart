import 'dart:typed_data';

class AccountData {
  final int? id;
  final String email;
  final String name;
  final String birthday;
  final String address;
  final Uint8List? picture;

  const AccountData({
    required this.id,
    required this.email,
    required this.name,
    required this.birthday,
    required this.address,
    required this.picture,
  });

  AccountData copyWith({
    int? id,
    String? email,
    String? name,
    String? birthday,
    String? address,
    Uint8List? picture,
  }) {
    return AccountData(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      birthday: birthday ?? this.birthday,
      address: address ?? this.address,
      picture: picture ?? this.picture,
    );
  }
}

class EmptyAccountData extends AccountData {
  const EmptyAccountData()
      : super(
          id: null,
          email: "",
          name: "",
          birthday: "",
          address: "",
          picture: null,
        );
}
