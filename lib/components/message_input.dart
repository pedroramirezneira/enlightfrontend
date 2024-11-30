import 'package:enlight/models/message_data.dart';
import 'package:enlight/util/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageInput extends StatefulWidget {
  final int senderId;
  final void Function(MessageData message)? onPressed;

  const MessageInput({
    super.key,
    required this.senderId,
    this.onPressed,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller.addListener(() {
      setState(() => controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).navigationBarTheme.indicatorColor;
    return LayoutBuilder(
      builder: (context, constraints) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: constraints.maxWidth * .8,
            child: FocusableActionDetector(
              shortcuts: {
                LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent()
              },
              actions: {
                ActivateIntent: CallbackAction<Intent>(onInvoke: (intent) {
                  if (Device.isComputer()) {
                    controller.text.trim().isEmpty ? null : _sendMessage();
                  }
                  return null;
                }),
              },
              child: TextField(
                controller: controller,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Message",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 60,
            width: 60,
            decoration: ShapeDecoration(
              shape: const CircleBorder(),
              color: surface,
            ),
            child: IconButton(
              onPressed: controller.text.trim().isEmpty ? null : _sendMessage,
              icon: const Icon(Icons.send_rounded),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (widget.onPressed != null) {
      final message = MessageData(
        sender_id: widget.senderId,
        message: controller.text.trim(),
        timestamp: DateTime.timestamp().toIso8601String(),
      );
      widget.onPressed!(message);
    }
    controller.clear();
  }
}
