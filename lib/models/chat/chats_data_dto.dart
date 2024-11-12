import 'package:enlight/macros/data_class.dart';
import 'package:enlight/models/account/account_data_dto.dart';
import 'package:enlight/models/chat/chat_data.dart';
import 'package:enlight/models/chat/chats_data.dart';
import 'package:json/json.dart';

@DataClass()
@JsonCodable()
class ChatsDataDto {
  final int id;
  final List<AccountDataDto> chats;

  ChatsData toData() {
    return ChatsData(
      accountId: id,
      chats: chats
          .map((chat) => ChatData(newMessages: 0, account: chat.toData()))
          .toList(),
    );
  }
}
