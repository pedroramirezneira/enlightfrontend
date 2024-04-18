import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final bool visible;

  const LoadingIndicator({
    super.key,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            color: Colors.black.withOpacity(0.5),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          const CircularProgressIndicator.adaptive(),
        ],
      ),
    );
  }
}
