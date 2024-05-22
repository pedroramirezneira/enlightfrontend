import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/chat_bubble.dart';
import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/models/chat_data.dart';
import 'package:enlight/pages/chat/chat.dart';
import 'package:enlight/util/chat_ops.dart';
import 'package:flutter/material.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  late final Future<ChatData> chats;
  @override
  void initState() {
    super.initState();
    chats = ChatOps.getChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: chats,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.all(10),
              width: 500,
              child: ListView.builder(
                itemCount: snapshot.data!.chats.length,
                itemBuilder: (context, index) => ChatBubble(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Chat(
                        senderId: snapshot.data!.accountId,
                        receiver: snapshot.data!.chats[index],
                      ),
                    ),
                  ),
                  name: snapshot.data!.chats[index].name,
                  picture: snapshot.data!.chats[index].picture,
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: AwesomeSnackbarContent(
                  title: "Error",
                  message: "Error loading chats",
                  contentType: ContentType.failure,
                ),
              ),
            );
          }
          return const LoadingIndicator(visible: true);
        },
      ),
    );
  }
}
