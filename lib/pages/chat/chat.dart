import 'package:enlight/components/loading_indicator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final int senderId;
  final int receiverId;

  const Chat({
    super.key,
    required this.senderId,
    required this.receiverId,
  });

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late final DatabaseReference chat;

  @override
  void initState() {
    super.initState();
    chat = FirebaseDatabase.instance.ref("chat");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: chat.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.snapshot.value.toString();
            return Text(data);
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
