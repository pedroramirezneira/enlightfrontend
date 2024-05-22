class MessageData {
  final int senderId;
  final String message;
  final DateTime timestamp;

  const MessageData({
    required this.senderId,
    required this.message,
    required this.timestamp,
  });

  factory MessageData.fromJson(Map<dynamic, dynamic> json) {
    final timestamp = DateTime.parse(json["timestamp"]);
    return MessageData(
      senderId: json["sender_id"],
      message: json["message"],
      timestamp: timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "sender_id": senderId,
      "message": message,
      "timestamp": timestamp.toIso8601String(),
    };
  }
}
