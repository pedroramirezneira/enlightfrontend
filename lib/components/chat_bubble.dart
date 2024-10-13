import 'dart:typed_data';
import 'package:badges/badges.dart' as badges;
import 'package:enlight/models/chats_data.dart';
import 'package:enlight/services/messaging_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final int index;
  final String name;
  final Uint8List? picture;
  final void Function() onTap;

  const ChatBubble({
    super.key,
    required this.index,
    required this.name,
    required this.picture,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = picture != null;
    return InkWell(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: hasImage ? MemoryImage(picture!) : null,
          ),
          const SizedBox(width: 10),
          Text(name),
          const SizedBox(width: 10),
          Consumer<MessagingService>(
            builder: (context, value, child) {
              if (value.data is! EmptyChatsData) {
                return badges.Badge(
                  showBadge: value.data.chats[index].newMessages > 0,
                  badgeContent: Text(
                    value.data.chats[index].newMessages.toString(),
                  ),
                );
              }
              return const Visibility(visible: false, child: Placeholder());
            },
          ),
        ],
      ),
    );
  }
}
