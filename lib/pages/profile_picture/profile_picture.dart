import 'package:enlight/models/account/account_data.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final AccountData receiver;

  const ProfilePicture({
    super.key,
    required this.receiver,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = receiver.picture != null;
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(receiver.name),
      ),
      body: Center(
        child: Hero(
          tag: "picture",
          child: hasImage
              ? Image.memory(
                  receiver.picture!,
                  width: size.width,
                  height: size.height,
                )
              : const Text("No image available."),
        ),
      ),
    );
  }
}
