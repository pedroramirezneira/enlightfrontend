import 'package:enlight/models/account_data.dart';

class ChatData {
  final int accountId;
  final List<AccountData> chats;

  ChatData({
    required this.accountId,
    required this.chats,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> chats = json["chats"];
    return ChatData(
      accountId: json["id"],
      chats: chats.map((e) => AccountData.fromJson(e)).toList(),
    );
  }
}
