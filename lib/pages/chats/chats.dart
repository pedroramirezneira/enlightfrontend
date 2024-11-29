import 'package:enlight/components/chat_bubble.dart';
import 'package:enlight/components/fixed_scaffold.dart';
import 'package:enlight/models/chat/chats_data.dart';
import 'package:enlight/pages/chat/chat.dart';
import 'package:enlight/services/auth_service.dart';
import 'package:enlight/services/messaging_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    final chatsService = Provider.of<MessagingService>(context);
    final authService = AuthService.of(context);
    final role = authService.role;
    if (chatsService.loading) {
      return const FixedScaffold(
          title: "Chats", body: CircularProgressIndicator.adaptive());
    }
    final isEmpty =
        chatsService.data is EmptyChatsData || chatsService.data.chats.isEmpty;
    if (isEmpty && role == 1) {
      return FixedScaffold(
        title: "Chats",
        body: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "You have no chats. Make a reservation to start chatting with teachers!",
              ),
            ],
          ),
        ),
      );
    }
    if (isEmpty) {
      return const FixedScaffold(
        title: "Chats",
        body: Text("You have no chats."),
      );
    }
    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          const SliverAppBar(
            title: Text("Chats"),
            floating: true,
            snap: true,
          ),
          SliverList.builder(
            itemCount: chatsService.data.chats.length,
            itemBuilder: (context, index) => ChatBubble(
              onTap: () {
                chatsService.readMessages(index);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Chat(
                      index: index,
                      receiver: chatsService.data.chats[index].account,
                      senderId: chatsService.data.accountId,
                    ),
                  ),
                );
              },
              index: index,
            ),
          ),
        ],
      ),
    );
  }
}
