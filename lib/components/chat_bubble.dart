import 'package:badges/badges.dart' as badges;
import 'package:enlight/services/messaging_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final int index;
  final void Function() onTap;

  const ChatBubble({
    super.key,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<MessagingService>(context);
    final chat = chatService.data.chats[index];
    final hasImage = chat.picture != null;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 24,
              backgroundImage: hasImage ? MemoryImage(chat.picture!) : null,
            ),
            const SizedBox(width: 16),
            Text(chat.name),
            const SizedBox(width: 16),
            badges.Badge(
              showBadge: chat.newMessages > 0,
              badgeContent: Text(
                chat.newMessages.toString(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
