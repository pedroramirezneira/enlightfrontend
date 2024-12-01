import 'dart:async';
import 'dart:convert';
import 'package:enlight/models/chat/chat_data.dart';
import 'package:enlight/models/chat/chat_unread_count.dart';
import 'package:enlight/models/chat/chats_data.dart';
import 'package:enlight/models/chat/chats_data_dto.dart';
import 'package:enlight/models/message_data.dart';
import 'package:enlight/util/web_client.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessagingService extends ChangeNotifier {
  ChatsData _data = EmptyChatsData();
  ChatsData get data => _data;
  int _newMessages = 0;
  int get newMessages => _newMessages;
  var _loading = true;
  bool get loading => _loading;
  final _listeners = <StreamSubscription<DatabaseEvent>>[];

  MessagingService({required BuildContext context}) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadChats(context);
      final updateRef = FirebaseDatabase.instance.ref("chat_update");
      final ref = updateRef.child(_data.accountId.toString());
      ref.onValue.listen((event) {
        if (!context.mounted) return;
        _loadChats(context);
      });
    });
  }

  Future<void> _loadChats(BuildContext context) async {
    final chats = await _fetchChatsFromServer(context);
    _updateLocalChats(chats);
    _loading = false;
    notifyListeners();
  }

  Future<ChatsData> _fetchChatsFromServer(BuildContext context) async {
    final response = await WebClient.get(context, "chat", info: false);
    if (response.statusCode != 200) return EmptyChatsData();
    final Map<String, dynamic> data = json.decode(response.body);
    return ChatsDataDto.fromJson(data).toData();
  }

  void _updateLocalChats(ChatsData newChats) {
    if (_data.chats.isEmpty) {
      _data = newChats;
      _data.chats.forEach(_createListener);
    } else {
      for (final c in newChats.chats) {
        if (_data.chats.indexWhere((e) => e.account.id == c.account.id) == -1) {
          _data.chats.add(c);
          _createListener(c);
        }
      }
    }
  }

  void sendMessage({
    required BuildContext context,
    required MessageData message,
  }) {
    final reference = FirebaseDatabase.instance.ref("chat");
    final list = [message.sender_id, message.receiver_id];
    list.sort();
    final chatKey = list.join("-");
    final messageKey = reference.child(chatKey).push().key;
    final Map<String, Map> updates = {};
    final messageData = message.toJson();
    updates['/$chatKey/$messageKey'] = messageData;
    reference.update(updates);
    final unread = FirebaseDatabase.instance.ref("chat_unread_count");
    final field = list.first == message.sender_id
        ? "second_unread_count"
        : "first_unread_count";
    final count = unread.child(chatKey).child(field);
    _increaseCount(count);
    WebClient.post(
      context,
      "chat/message",
      body: json.encode(messageData),
      headers: {
        "Content-Type": "application/json",
      },
      info: false,
    );
  }

  void _increaseCount(DatabaseReference count) {
    count.runTransaction((value) {
      if (value == null || value is! int || value == 0) {
        return Transaction.success(1);
      }
      return Transaction.success((value) + 1);
    });
  }

  void _resetCount(DatabaseReference count) {
    count.set(0);
  }

  void _createListener(ChatData chat) {
    final database = FirebaseDatabase.instance.ref("chat_unread_count");
    final list = [data.accountId, chat.account.id];
    list.sort();
    final chatKey = list.join("-");
    final ref = database.child(chatKey);
    _listeners.add(
      ref.onValue.listen(
        (event) {
          final data = event.snapshot.value as Map<Object?, Object?>;
          final result = ChatUnreadCount.fromJson(data.cast<String, dynamic>());
          final int unreadCount;
          if (_data.accountId < chat.account.id) {
            unreadCount = result.first_unread_count;
          } else {
            unreadCount = result.second_unread_count;
          }
          chat.newMessages = unreadCount;
          _newMessages = _data.chats.fold<int>(
            0,
            (previousValue, element) => previousValue + element.newMessages,
          );
          notifyListeners();
        },
        onError: (error) => null,
      ),
    );
  }

  void readMessages(int index) {
    final unread = FirebaseDatabase.instance.ref("chat_unread_count");
    final list = [_data.accountId, _data.chats[index].account.id]..sort();
    final chatKey = list.join("-");
    final field = list.first == _data.accountId
        ? "first_unread_count"
        : "second_unread_count";
    final count = unread.child(chatKey).child(field);
    _resetCount(count);
  }

  Future<void> createChat(BuildContext context, int receiverId) async {
    final response = await WebClient.post(
      context,
      info: false,
      "chat",
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(
        {
          "receiver_id": receiverId,
        },
      ),
    );
    if (response.statusCode == 200) {
      if (!context.mounted) return;
      _notifyFirebase(receiverId);
      await _loadChats(context);
      notifyListeners();
    }
  }

  void _notifyFirebase(int id) {
    final database = FirebaseDatabase.instance.ref("chat_update");
    final ref = database.child(id.toString());
    final key = ref.push().key!;
    final Map<String, dynamic> updates = {};
    updates[key] = "si";
    ref.update(updates);
  }
}
