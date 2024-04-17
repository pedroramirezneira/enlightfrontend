import 'package:enlight/models/category_data.dart';
import 'package:flutter/material.dart';

class EnlightAutocompleteField extends StatelessWidget {
  final String text;
  final List<CategoryData> data;
  final TextEditingController controller;

  const EnlightAutocompleteField({
    super.key,
    required this.text,
    required this.data,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Autocomplete<String>(
        optionsBuilder: (textEditingValue) {
          controller.text = textEditingValue.text;
          if (textEditingValue.text == "") {
            return const Iterable<String>.empty();
          }
          return data.map((category) => category.name).where((name) {
            return name.contains(textEditingValue.text.toLowerCase());
          });
        },
      ),
    );
  }
}
