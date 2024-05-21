import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late final WebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(
      Uri.parse("ws://${dotenv.env["SERVER"]}/chat")
    );
    channel.sink.add("Hello from Flutter!");
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
