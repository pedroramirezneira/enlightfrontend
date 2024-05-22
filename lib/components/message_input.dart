import 'package:enlight/models/message_data.dart';
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
    final surface = Theme.of(context).colorScheme.surface;
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
                ActivateIntent: CallbackAction<Intent>(
                  onInvoke: (intent) {
                    if (controller.text.trim().isEmpty) {
                      return null;
                    }
                    if (widget.onPressed != null) {
                      final message = MessageData(
                        senderId: widget.senderId,
                        message: controller.text,
                        timestamp: DateTime.timestamp(),
                      );
                      widget.onPressed!(message);
                    }
                    controller.clear();
                    return null;
                  },
                ),
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
              onPressed: controller.text.trim().isEmpty
                  ? null
                  : () {
                      if (widget.onPressed != null) {
                        final message = MessageData(
                          senderId: widget.senderId,
                          message: controller.text,
                          timestamp: DateTime.timestamp(),
                        );
                        widget.onPressed!(message);
                      }
                      controller.clear();
                    },
              icon: const Icon(Icons.send_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
