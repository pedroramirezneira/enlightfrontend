import 'package:flutter/material.dart';

class FixedScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const FixedScaffold({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(child: body),
    );
  }
}
