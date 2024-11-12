import 'package:enlight/macros/data_class.dart';
import 'package:enlight/models/chat/chat_data.dart';

@DataClass()
class ChatsData {
  final int accountId;
  final List<ChatData> chats;
}

class EmptyChatsData extends ChatsData {
  EmptyChatsData() : super(accountId: -1, chats: const []);
}
