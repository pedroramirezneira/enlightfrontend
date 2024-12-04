import 'package:flutter/material.dart';

class FilterMenu extends StatefulWidget {
  final void Function(Map<String, String> selectedValues)? onApply;

  const FilterMenu({
    super.key,
    this.onApply,
  });

  @override
  State<FilterMenu> createState() => _FilterMenuState();
}

class _FilterMenuState extends State<FilterMenu> {
  final Map<String, List<String>> _filters = {
    "Category 1": ["Option 1.1", "Option 1.2", "Option 1.3"],
    "Category 2": ["Option 2.1", "Option 2.2", "Option 2.3"],
    "Category 3": ["Option 3.1", "Option 3.2", "Option 3.3"],
  };

  final Map<String, String> _selectedValues = {};

  @override
  void initState() {
    super.initState();
    // Initialize selected values with the first option for each filter
    _filters.forEach((category, options) {
      _selectedValues[category] = options.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Filter Menu",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ..._filters.keys.map((category) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: category,
                  border: const OutlineInputBorder(),
                ),
                value: _selectedValues[category],
                items: _filters[category]!.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Row(
                      children: [
                        Radio<String>(
                          value: option,
                          groupValue: _selectedValues[category],
                          onChanged: (value) {
                            setState(() {
                              _selectedValues[category] = value!;
                            });
                          },
                        ),
                        Text(option),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedValues[category] = value!;
                  });
                },
              ),
            );
          }),
          ElevatedButton(
            onPressed: () {
              widget.onApply?.call(_selectedValues);
              Overlay.of(context).dispose();
            },
            child: const Text("Apply Filters"),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
