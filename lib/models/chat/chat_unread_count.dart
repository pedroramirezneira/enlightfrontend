// ignore_for_file: non_constant_identifier_names

class ChatUnreadCount {
  final int first_unread_count;
  final int second_unread_count;

  const ChatUnreadCount({
    required this.first_unread_count,
    required this.second_unread_count,
  });

  factory ChatUnreadCount.fromJson(Map<String, dynamic> json) {
    return ChatUnreadCount(
      first_unread_count: json['first_unread_count'],
      second_unread_count: json['second_unread_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_unread_count': first_unread_count,
      'second_unread_count': second_unread_count,
    };
  }
}
