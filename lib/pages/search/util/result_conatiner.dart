import 'package:flutter/material.dart';

class ResultContainer extends StatefulWidget {
  final String name;
  final String description;
  final String? picture;

  const ResultContainer({
    super.key,
    required this.name,
    required this.description,
    required this.picture,
  });

  @override
  State<ResultContainer> createState() => _ResultContainer();
}

class _ResultContainer extends State<ResultContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 71, 129, 118),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
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
                      widget.description,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
