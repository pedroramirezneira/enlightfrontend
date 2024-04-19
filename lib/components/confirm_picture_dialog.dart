import 'dart:typed_data';
import 'package:flutter/material.dart';

class ConfirmPictureDialog extends StatelessWidget {
  final Uint8List bytes;

  const ConfirmPictureDialog({
    super.key,
    required this.bytes,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: const Text("Update profile picture"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Are you sure you want to update your profile picture?"),
          const SizedBox(
            height: 15,
          ),
          Image.memory(
            bytes,
            width: 150,
            height: 150,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("OK"),
        ),
      ],
    );
  }
}
