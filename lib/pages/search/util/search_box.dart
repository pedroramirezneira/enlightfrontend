import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  final String hintText;
  final Function(String) onSubmitted;

  const SearchBox(
      {super.key, required this.hintText, required this.onSubmitted});

  @override
  // ignore: library_private_types_in_public_api
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.7,
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onSubmitted: (value) {
              widget.onSubmitted(value);
            },
          ),
        ),
      ),
    );
  }
}
