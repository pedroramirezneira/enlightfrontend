import 'package:flutter/material.dart';

class PictureMenu extends StatelessWidget {
  final void Function()? selectFromGallery;
  final void Function()? takePhoto;

  const PictureMenu({
    super.key,
    this.selectFromGallery,
    this.takePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: [
              IconButton(
                onPressed: selectFromGallery,
                icon: const Icon(
                  Icons.photo,
                  size: 30,
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
                  size: 30,
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
