import 'package:flutter/material.dart';

class EnlightTextFormField extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const EnlightTextFormField({
    super.key,
    required this.text,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        validator: validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return "$text cannot be empty.";
              }
              return null;
            },
        decoration: InputDecoration(
          labelText: text,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
