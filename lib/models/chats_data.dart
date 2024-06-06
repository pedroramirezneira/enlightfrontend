import 'package:enlight/models/chat_data.dart';

class ChatsData {
  final int accountId;
  final List<ChatData> chats;

  ChatsData({
    required this.accountId,
    required this.chats,
  });

  factory ChatsData.fromJson(Map<String, dynamic> json) {
    final List<dynamic> chats = json["chats"];
    return ChatsData(
      accountId: json["id"],
      chats: chats.map((e) => ChatData.fromJson(e)).toList(),
    );
  }
}
