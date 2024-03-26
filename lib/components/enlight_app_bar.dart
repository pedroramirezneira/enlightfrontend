import 'package:flutter/material.dart';

class EnlightAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  const EnlightAppBar({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(text));
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
