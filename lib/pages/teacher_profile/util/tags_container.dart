import 'package:flutter/material.dart';

class TagContainer extends StatefulWidget {
  final String name;
  final String description;
  final int price;
  final VoidCallback deleteSubject;

  const TagContainer({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    required this.deleteSubject,
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
            color: const Color.fromARGB(255, 71, 129, 118),
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
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                child: Text(
                  "price: \$${widget.price}",
                  style: const TextStyle(
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
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                child: TextButton(
                  onPressed: () {
                    widget.deleteSubject();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.all(12),
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
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
