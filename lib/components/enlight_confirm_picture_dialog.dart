import 'dart:typed_data';
import 'package:flutter/material.dart';

class EnlightConfirmPictureDialog extends StatelessWidget {
  final Uint8List bytes;
  final void Function()? onConfirm;
  final void Function()? onCancel;

  const EnlightConfirmPictureDialog({
    super.key,
    required this.bytes,
    this.onConfirm,
    this.onCancel,
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
          onPressed: onCancel,
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: onConfirm,
          child: const Text("OK"),
        ),
      ],
    );
  }
}
