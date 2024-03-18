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
      child: MaterialButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            onPressed!();
          }
        },
        minWidth: double.infinity,
        height: 50,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        color: Colors.grey.shade700,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
