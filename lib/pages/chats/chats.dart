import 'package:enlight/components/chat_bubble.dart';
import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/models/chats_data.dart';
import 'package:enlight/pages/chat/chat.dart';
import 'package:enlight/services/messaging_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ChatsData>(
        builder: (context, value, child) {
          if (value is EmptyChatsData) {
            return const Center(
              child: LoadingIndicator(visible: true),
            );
          }
          if (value.chats.isEmpty) {
            return const Center(
              child: Text(
                "You have no chats. Make a reservation to start chatting with teachers!",
              ),
            );
          }
          return Container(
            padding: const EdgeInsets.all(10),
            width: 500,
            child: ListView.builder(
              itemCount: value.chats.length,
              itemBuilder: (context, index) => ChatBubble(
                onTap: () {
                  context.read<MessagingService>().readMessages(index);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Chat(
                        senderId: value.accountId,
                        receiver: value.chats[index],
                        index: index,
                      ),
                    ),
                  );
                },
                index: index,
                name: value.chats[index].name,
                picture: value.chats[index].picture,
              ),
            ),
          );
        },
      ),
    );
  }
}
