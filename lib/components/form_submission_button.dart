import 'package:flutter/material.dart';

class FormSubmissionButton extends StatelessWidget {
  final String text;
  final GlobalKey<FormState> formKey;
  final void Function()? onPressed;

  const FormSubmissionButton({
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
