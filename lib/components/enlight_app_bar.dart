import 'package:flutter/material.dart';

class EnlightAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final List<Widget>? actions;

  const EnlightAppBar({
    super.key,
    required this.text,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(text),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
