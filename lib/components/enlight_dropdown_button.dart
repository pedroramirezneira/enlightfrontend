import 'package:flutter/material.dart';

class EnlightDropdownButton extends StatelessWidget {
  final String text;
  final List<String> items;
  final String value;
  final void Function(String?)? onChanged;

  const EnlightDropdownButton({
    super.key,
    required this.text,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.grey.shade400,
    );
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          underline: Container(),
          items: List.generate(
            items.length + 1,
            (index) => index == 0
                ? DropdownMenuItem(
                    value: text,
                    child: Text(
                      text,
                      style: textStyle,
                    ),
                  )
                : DropdownMenuItem(
                    value: items[index - 1],
                    child: Text(
                      items[index - 1],
                      style: textStyle,
                    ),
                  ),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
