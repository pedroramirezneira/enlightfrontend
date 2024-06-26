import 'package:flutter/material.dart';

class SelectableTimeslot extends StatefulWidget {
  final String text;
  final void Function() onPressed;

  const SelectableTimeslot({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<SelectableTimeslot> createState() => _SelectableTimeslotState();
}

class _SelectableTimeslotState extends State<SelectableTimeslot> {
  late bool selected;

  @override
  void initState() {
    super.initState();
    selected = false;
  }

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).navigationBarTheme.indicatorColor!;
    final background = Theme.of(context).colorScheme.surface;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 150,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              selected ? surface : background,
            ),
            side: WidgetStatePropertyAll(
              BorderSide(
                width: 1,
                color: onPrimary,
              ),
            ),
          ),
          onPressed: () {
            setState(() => selected = !selected);
            widget.onPressed();
          },
          child: Text(widget.text),
        ),
      ),
    );
  }
}
