import 'package:enlight/components/enlight_text_field.dart';
import 'package:enlight/models/category_data.dart';
import 'package:flutter/material.dart';

class AutocompleteField extends StatelessWidget {
  final String text;
  final List<CategoryData> data;
  final TextEditingController controller;

  const AutocompleteField({
    super.key,
    required this.text,
    required this.data,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (textEditingValue) {
        controller.text = textEditingValue.text;
        if (textEditingValue.text == "") {
          return const Iterable<String>.empty();
        }
        return data.map((category) => category.name).where((name) {
          return name
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return EnlightTextField(
          text: text,
          controller: textEditingController,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
        );
      },
    );
  }
}
