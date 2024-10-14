import 'package:flutter/material.dart';

class FixedScaffold extends StatelessWidget {
  final String title;
  final Widget child;

  const FixedScaffold({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(child: child),
    );
  }
}
