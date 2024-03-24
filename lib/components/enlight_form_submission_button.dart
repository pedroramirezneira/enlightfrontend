import 'package:flutter/material.dart';

class EnlightFormSubmissionButton extends StatelessWidget {
  final String text;
  final GlobalKey<FormState> formKey;
  final Function()? onPressed;

  const EnlightFormSubmissionButton({
    super.key,
    required this.text,
    required this.formKey,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            onPressed!();
          }
        },
        child: Text(text),
      ),
    );
  }
}
