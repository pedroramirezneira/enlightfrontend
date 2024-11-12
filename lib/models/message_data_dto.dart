import 'package:enlight/macros/data_class.dart';
import 'package:enlight/models/message_data.dart';
import 'package:json/json.dart';

@DataClass()
@JsonCodable()
class MessageDataDto {
  // ignore: non_constant_identifier_names
  final int sender_id;
  final String message;
  final String timestamp;

  MessageData toData() {
    return MessageData(
      senderId: sender_id,
      message: message,
      timestamp: DateTime.parse(timestamp),
    );
  }
}
