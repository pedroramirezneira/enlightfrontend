import 'dart:convert';

import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String name;
  final String? picture;
  final void Function() onTap;

  const ChatBubble({
    super.key,
    required this.name,
    required this.picture,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = picture != null;
    final decoded = base64.decode(picture ?? "");
    return InkWell(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: hasImage ? MemoryImage(decoded) : null,
          ),
          const SizedBox(width: 10),
          Text(name),
        ],
      ),
    );
  }
}
