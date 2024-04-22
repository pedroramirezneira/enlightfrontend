import 'package:flutter/material.dart';

class Timeslot extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const Timeslot({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 71, 129, 118),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
            IconButton(
              onPressed: onPressed,
              icon: const Icon(
                Icons.delete_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
