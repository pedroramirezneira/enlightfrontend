import 'dart:async';
import 'package:enlight/models/chats_data.dart';
import 'package:enlight/models/message_data.dart';
import 'package:enlight/util/chat_ops.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MessagingService extends ChangeNotifier {
  late Future<ChatsData>? chats;
  int _newMessages = 0;
  int get newMessages => _newMessages;

  MessagingService() {
    chats = ChatOps.getChats();
    final database = FirebaseDatabase.instance.ref("chat");
    chats!.then((value) {
      _newMessages = -value.chats.length;
      for (final chat in value.chats) {
        final list = [value.accountId, chat.id];
        list.sort();
        final chatKey = list.join("-");
        // FirebaseMessaging.instance.subscribeToTopic(chatKey);
        final ref = database.child(chatKey);
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
                if (messages.last.senderId != value.accountId) {
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
        );
      }
    });
  }

  void readMessages(int index) {
    chats!.then(
      (value) {
        final messages = value.chats[index].newMessages;
        value.chats[index].newMessages = 0;
        _newMessages -= messages;
        notifyListeners();
      },
    );
  }

  void refreshChats() {
    chats = ChatOps.getChats();
    notifyListeners();
    chats!.then(
      (value) => notifyListeners(),
    );
  }
}
