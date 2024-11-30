import 'package:enlight/models/chat/chat_data.dart';

class ChatsData {
  final int accountId;
  final List<ChatData> chats;

  const ChatsData({
    required this.accountId,
    required this.chats,
  });
}

class EmptyChatsData extends ChatsData {
  EmptyChatsData() : super(accountId: -1, chats: const []);
}
