import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/components/message_bubble.dart';
import 'package:enlight/components/message_input.dart';
import 'package:enlight/models/account_data.dart';
import 'package:enlight/models/message_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final int senderId;
  final AccountData receiver;

  const Chat({
    super.key,
    required this.senderId,
    required this.receiver,
  });

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late final DatabaseReference chat;
  late final String chatKey;

  @override
  void initState() {
    super.initState();
    chat = FirebaseDatabase.instance.ref("chat");
    final list = [widget.senderId, widget.receiver.id];
    list.sort();
    chatKey = list.join("-");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiver.name)),
      body: StreamBuilder(
        stream: chat.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.snapshot.value == null) {
              return const Placeholder();
            }
            List<MessageData> messages;
            try {
              final data =
                  snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
              final chatData = data[chatKey] as Map<dynamic, dynamic>;
              messages = chatData.entries
                  .map((entry) => MessageData.fromJson(entry.value))
                  .toList()
                ..sort(((a, b) => b.timestamp.compareTo(a.timestamp)));
            } catch (error) {
              messages = [];
            }
            return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: 500,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) => Align(
                          alignment: messages[index].senderId == widget.senderId
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Column(
                            children: <Widget>[
                              MessageBubble(
                                data: messages[index],
                                isSender:
                                    messages[index].senderId == widget.senderId,
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    MessageInput(
                      senderId: widget.senderId,
                      onPressed: (MessageData message) {
                        final messageKey = chat.child("chatKey").push().key;
                        final Map<String, dynamic> updates = {};
                        updates["$chatKey/$messageKey"] = message.toJson();
                        chat.update(updates);
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return const LoadingIndicator(visible: true);
        },
      ),
    );
  }
}
