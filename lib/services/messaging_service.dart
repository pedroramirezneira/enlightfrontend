import 'dart:async';
import 'dart:convert';
import 'package:enlight/models/chat/chat_data.dart';
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

  void sendMessage({
    required int receiverId,
    required MessageData message,
  }) {
    final reference = FirebaseDatabase.instance.ref("chat");
    final list = [message.sender_id, receiverId];
    list.sort();
    final chatKey = list.join("-");
    final messageKey = reference.child(chatKey).push().key;
    final Map<String, Map> updates = {};
    final messageData = message.toJson();
    updates['/$chatKey/$messageKey'] = messageData;
    reference.update(updates);
  }

  Future<void> _loadChats(BuildContext context) async {
    // Fetch initial data
    final response = await WebClient.get(context, "chat", info: false);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final result = ChatsDataDto.fromJson(data);
      if (_data.chats.isEmpty) {
        _data = result.toData();
        _newMessages = -_data.chats.length;
        for (final chat in _data.chats) {
          _createListener(chat);
        }
      } else {
        result.toData().chats.forEach((c) {
          final index = _data.chats.indexWhere(
            (e) => e.account.id == c.account.id,
          );
          if (index == -1) {
            _data.chats.add(c);
            _data.chats.last.newMessages = 0;
            _createListener(c);
          }
        });
      }
      _loading = false;
      notifyListeners();
    }
  }

  void _createListener(ChatData chat) {
    final database = FirebaseDatabase.instance.ref("chat");
    final list = [data.accountId, chat.account.id];
    list.sort();
    final chatKey = list.join("-");
    final ref = database.child(chatKey);
    _listeners.add(
      ref.onValue.listen(
        (event) {
          final data = event.snapshot.value as Map<Object?, Object?>;
          final result = data.entries
              .map((e) => MessageData.fromJson(
                  (e.value as Map<Object?, Object?>).cast<String, Object?>()))
              .toList();
          final messages = result;
          messages.sort((a, b) =>
              _getDateTime(a.timestamp).compareTo(_getDateTime(b.timestamp)));
          if (messages.last.sender_id != this.data.accountId) {
            chat.newMessages++;
            _newMessages++;
            notifyListeners();
          }
        },
        onError: (error) => null,
      ),
    );
  }

  DateTime _getDateTime(String timestamp) {
    final date = DateTime.parse(timestamp);
    return date;
  }

  void readMessages(int index) {
    final messages = data.chats[index].newMessages;
    data.chats[index].newMessages = 0;
    _newMessages -= messages;
    notifyListeners();
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
