import 'package:flutter/material.dart';

class EnlightBottomSheet extends StatelessWidget {
  final void Function()? selectFromGallery;
  final void Function()? takePhoto;

  const EnlightBottomSheet({
    super.key,
    this.selectFromGallery,
    this.takePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: [
              IconButton(
                onPressed: selectFromGallery,
                icon: const Icon(
                  Icons.photo,
                  size: 40,
                ),
              ),
              const Text("Select photo"),
            ],
          ),
          Column(
            children: [
              IconButton(
                onPressed: takePhoto,
                icon: const Icon(
                  Icons.photo_camera,
                  size: 40,
                ),
              ),
              const Text("Take photo"),
            ],
          ),
        ],
      ),
    );
  }
}
