import 'package:enlight/components/filter_menu.dart';
import 'package:flutter/material.dart';

void showOverlayMenu(BuildContext context,
    {required void Function(Map<String, String>) onApply}) {
  final overlay = Overlay.of(context);
  late final OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 100,
      left: 50,
      right: 50,
      child: FilterMenu(
        onApply: (selectedValues) {
          onApply(selectedValues);
          overlayEntry.remove();
        },
      ),
    ),
  );
  overlay.insert(overlayEntry);
}
