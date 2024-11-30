import 'package:enlight/models/message_data.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final MessageData data;
  final bool isSender;

  const MessageBubble({
    super.key,
    required this.data,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    final timestamp = DateTime.parse(data.timestamp).toLocal();
    final theme = Theme.of(context);
    final surface = theme.navigationBarTheme.indicatorColor!;
    var hour = timestamp.hour.toString();
    while (hour.length < 2) {
      hour = "0$hour";
    }
    var minute = timestamp.minute.toString();
    while (minute.length < 2) {
      minute = "0$minute";
    }
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        constraints: BoxConstraints(maxWidth: constraints.maxWidth - 50),
        decoration: BoxDecoration(
          color: isSender
              ? surface.withOpacity(0.5)
              : Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Wrap(
          alignment: WrapAlignment.end,
          children: [
            Text(
              data.message,
              maxLines: null,
            ),
            const SizedBox(width: 20),
            Text(
              "$hour:$minute",
            ),
          ],
        ),
      ),
    );
  }
}
