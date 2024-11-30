// ignore_for_file: non_constant_identifier_names

class MessageData {
  final int sender_id;
  final String message;
  final String timestamp;

  MessageData({
    required this.sender_id,
    required this.message,
    required this.timestamp,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      sender_id: json['sender_id'],
      message: json['message'],
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sender_id': sender_id,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
