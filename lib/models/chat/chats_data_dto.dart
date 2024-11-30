import 'package:enlight/models/account/account_data_dto.dart';
import 'package:enlight/models/chat/chat_data.dart';
import 'package:enlight/models/chat/chats_data.dart';

class ChatsDataDto {
  final int id;
  final List<AccountDataDto> chats;

  const ChatsDataDto({
    required this.id,
    required this.chats,
  });

  factory ChatsDataDto.fromJson(Map<String, dynamic> json) {
    return ChatsDataDto(
      id: json['id'],
      chats: (json['chats'] as List)
          .map((e) => AccountDataDto.fromJson(e))
          .toList(),
    );
  }

  ChatsData toData() {
    return ChatsData(
      accountId: id,
      chats: chats.map((chat) => ChatData(account: chat.toData())).toList(),
    );
  }
}
