import 'dart:typed_data';
import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/components/message_bubble.dart';
import 'package:enlight/components/message_input.dart';
import 'package:enlight/models/account/account_data.dart';
import 'package:enlight/models/message_data.dart';
import 'package:enlight/pages/profile_picture/profile_picture.dart';
import 'package:enlight/services/messaging_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  final int senderId;
  final AccountData receiver;
  final int index;

  const Chat({
    super.key,
    required this.senderId,
    required this.receiver,
    required this.index,
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
    final messagingService = Provider.of<MessagingService>(context);
    final hasImage = widget.receiver.picture != null;
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            if (!hasImage) return;
            Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                barrierDismissible: true,
                builder: (context) => ProfilePicture(
                  receiver: widget.receiver,
                ),
              ),
            );
          },
          child: Row(
            children: <Widget>[
              Hero(
                tag: "picture",
                child: CircleAvatar(
                  backgroundImage: hasImage
                      ? MemoryImage(
                          widget.receiver.picture ?? Uint8List(0),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 20),
              Text(widget.receiver.name),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: chat.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.snapshot.value == null) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: 500,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      MessageInput(
                        senderId: widget.senderId,
                        receiverId: widget.receiver.id!,
                        onPressed: (MessageData message) {
                          messagingService.sendMessage(
                            context: context,
                            message: message,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            }
            List<MessageData> messages;
            try {
              final data =
                  snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
              final chatData = data[chatKey] as Map<dynamic, dynamic>;
              messages = chatData.entries.map((entry) {
                final data = Map<String, dynamic>.fromEntries(
                  (entry.value as Map)
                      .entries
                      .map((e) => MapEntry(e.key.toString(), e.value)),
                );
                return MessageData.fromJson(data);
              }).toList()
                ..sort(
                  ((a, b) => DateTime.parse(b.timestamp).compareTo(
                        DateTime.parse(a.timestamp),
                      )),
                );
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
                        itemBuilder: (context, index) => Column(
                          children: <Widget>[
                            () {
                              final timestamp =
                                  DateTime.parse(messages[index].timestamp)
                                      .toLocal();
                              final date =
                                  DateFormat("MMMM d, yyyy").format(timestamp);
                              if (index == messages.length - 1) {
                                return Text(date);
                              }
                              final previous =
                                  DateTime.parse(messages[index + 1].timestamp)
                                      .toLocal();
                              if (date !=
                                  DateFormat("MMMM d, yyyy").format(previous)) {
                                return Text(date);
                              }
                              return const Visibility(
                                visible: false,
                                child: Placeholder(),
                              );
                            }(),
                            Align(
                              alignment:
                                  messages[index].sender_id == widget.senderId
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                              child: MessageBubble(
                                data: messages[index],
                                isSender: messages[index].sender_id ==
                                    widget.senderId,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    MessageInput(
                      senderId: widget.senderId,
                      receiverId: widget.receiver.id!,
                      onPressed: (MessageData message) {
                        messagingService.sendMessage(
                          context: context,
                          message: message,
                        );
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
