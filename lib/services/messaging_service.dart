import 'dart:async';
import 'dart:convert';
import 'package:enlight/models/chats_data.dart';
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
      final database = FirebaseDatabase.instance.ref("chat_update");
      final response = await WebClient.get(context, "chat", info: false);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _data = ChatsData.fromJson(data);
        final ref = database.child(_data.accountId.toString());
        ref.onValue.listen((_) => refreshChats(context));
      }
    });
  }

  Future<void> refreshChats(BuildContext context) async {
    for (var e in _listeners) {
      e.cancel();
    }
    _listeners.clear();
    // Fetch initial data
    final database = FirebaseDatabase.instance.ref("chat");
    final response = await WebClient.get(context, "chat", info: false);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      _data = ChatsData.fromJson(data);
      _loading = false;
      notifyListeners();
    }
    if (!context.mounted) return;
    // Listen for changes
    _newMessages = -data.chats.length;
    for (final chat in data.chats) {
      final list = [data.accountId, chat.id];
      list.sort();
      final chatKey = list.join("-");
      final ref = database.child(chatKey);
      _listeners.add(
        ref.onValue.listen(
          (event) {
            if (newMessages >= 0) {
              try {
                final data = event.snapshot.value as Map<dynamic, dynamic>;
                final messages = data.entries
                    .map(
                      (e) => MessageData.fromJson(e.value),
                    )
                    .toList();
                messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
                if (messages.last.senderId != this.data.accountId) {
                  chat.newMessages++;
                  _newMessages++;
                  notifyListeners();
                }
              } catch (error) {
                null;
              }
            } else {
              _newMessages++;
              notifyListeners();
            }
          },
          onError: (error) => null,
        ),
      );
    }
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
      await refreshChats(context);
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
