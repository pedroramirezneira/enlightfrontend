import 'dart:typed_data';
import 'package:enlight/models/account/account_data.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final AccountData receiver;
  final Uint8List picture;

  const ProfilePicture({
    super.key,
    required this.receiver,
    required this.picture,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(receiver.name),
      ),
      body: Center(
        child: Hero(
          tag: "picture",
          child: Image.memory(
            picture,
            width: size.width,
            height: size.height,
          ),
        ),
      ),
    );
  }
}
