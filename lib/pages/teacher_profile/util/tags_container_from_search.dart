import 'package:enlight/pages/subject/subject.dart';
import 'package:flutter/material.dart';

class TagContainerFromSearch extends StatefulWidget {
  final int subjectId;
  final String name;
  final String description;
  final int price;

  const TagContainerFromSearch({
    super.key,
    required this.subjectId,
    required this.name,
    required this.price,
    required this.description,
  });

  @override
  State<TagContainerFromSearch> createState() => _TagContainer();
}

class _TagContainer extends State<TagContainerFromSearch> {
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
      child: Padding(
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
                const SizedBox(
                  height: 5,
                ),
              ],
            )),
      ),
    );
  }
}
