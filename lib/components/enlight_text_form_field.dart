import 'package:flutter/material.dart';

class EnlightTextFormField extends StatefulWidget {
  final String text;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool password;

  const EnlightTextFormField({
    super.key,
    required this.text,
    required this.controller,
    this.validator,
    this.password = false,
  });

  @override
  State<EnlightTextFormField> createState() => _EnlightTextFormFieldState();
}

class _EnlightTextFormFieldState extends State<EnlightTextFormField> {
  late bool obscure;

  @override
  void initState() {
    super.initState();
    obscure = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: widget.controller,
        obscureText: obscure,
        validator: widget.validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return "${widget.text} cannot be empty.";
              }
              return null;
            },
        decoration: InputDecoration(
          labelText: widget.text,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          suffixIcon: widget.password
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
