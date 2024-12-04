import 'package:enlight/pages/subject/subject.dart';
import 'package:flutter/material.dart';

class SubjectResultContainer extends StatefulWidget {
  final int price;
  final int subjectId;
  final String name;
  final String description;

  const SubjectResultContainer({
    super.key,
    required this.price,
    required this.subjectId,
    required this.name,
    required this.description,
  });

  @override
  State<SubjectResultContainer> createState() => _SubjectResultContainer();
}

class _SubjectResultContainer extends State<SubjectResultContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Subject(
            id: widget.subjectId,
          ),
        ),
      ),
      child: Container(
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
                Text(
                  "\$${widget.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                  child: Text(
                    maxLines: 2,
                    widget.description,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
