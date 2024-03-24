import 'package:flutter/material.dart';

class EnlightAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EnlightAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(title: const Text("Enlight"));
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
