import 'package:flutter/material.dart';

class EnlightSelectPictureDialog extends StatelessWidget {
  final Function()? selectFromGallery;
  final Function()? takePhoto;

  const EnlightSelectPictureDialog({
    super.key,
    required this.selectFromGallery,
    required this.takePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: const Text("Update profile picture"),
      actions: [
        TextButton(
          onPressed: selectFromGallery,
          child: const Text("Select from gallery"),
        ),
        TextButton(
          onPressed: takePhoto,
          child: const Text("Take photo"),
        ),
      ],
    );
  }
}
