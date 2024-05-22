import 'package:firebase_database/firebase_database.dart';

void sendMessage({
  required DatabaseReference reference,
  required int senderId,
  required int receiverId,
  required String message,
}) {
  final list = [senderId, receiverId];
  list.sort();
  final chatKey = list.join();
  final messageKey = reference.child(chatKey).push().key;
  final Map<String, Map> updates = {};
  final messageData = {
    "timestamp": DateTime.timestamp(),
    "sender_id": senderId,
    "receiver_id": receiverId,
    "message": message,
  };
  updates['/$chatKey/$messageKey'] = messageData;
  reference.update(updates);
}
