import 'package:flutter/material.dart';

class TagContainer extends StatefulWidget {
  final String name;
  final String description;

  const TagContainer({
    super.key,
    required this.name,
    required this.description,
  });

  @override
  State<TagContainer> createState() => _TagContainer();
}

class _TagContainer extends State<TagContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(30, 57, 210, 192),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                widget.name,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  letterSpacing: 0,
                ),
              ),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                child: Text(
                  "price: \$100",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    letterSpacing: 0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                child: Text(
                  widget.description,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          )),
    );
  }
}
