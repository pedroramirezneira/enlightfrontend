import 'dart:typed_data';
import 'package:badges/badges.dart' as badges;
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
            backgroundImage: hasImage
                ? MemoryImage(
                    picture ?? Uint8List(0),
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Text(name),
          const SizedBox(width: 10),
          Consumer<MessagingService>(
            builder: (context, value, child) => FutureBuilder(
              future: value.chats,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return badges.Badge(
                    showBadge: snapshot.data!.chats[index].newMessages > 0,
                    badgeContent: Text(
                      snapshot.data!.chats[index].newMessages.toString(),
                    ),
                  );
                }
                return const Visibility(visible: false, child: Placeholder());
              },
            ),
          ),
        ],
      ),
    );
  }
}
