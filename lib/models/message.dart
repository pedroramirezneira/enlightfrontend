class Message {
  final String senderId;
  final String message;
  final DateTime timestamp;

  const Message({
    required this.senderId,
    required this.message,
    required this.timestamp,
  });
}
