// ignore_for_file: non_constant_identifier_names

class MessageData {
  final int sender_id;
  final int receiver_id;
  final String message;
  final String timestamp;

  MessageData({
    required this.sender_id,
    required this.receiver_id,
    required this.message,
    required this.timestamp,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      sender_id: json['sender_id'],
      receiver_id: json['receiver_id'],
      message: json['message'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_id': sender_id,
      'receiver_id': receiver_id,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
