import 'package:flutter/material.dart';

class PictureMenu extends StatelessWidget {
  const PictureMenu({super.key});

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
                onPressed: () => Navigator.of(context).pop("select"),
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
                onPressed: () => Navigator.of(context).pop("take"),
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
