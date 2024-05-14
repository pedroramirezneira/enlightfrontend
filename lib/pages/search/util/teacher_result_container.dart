import 'package:enlight/pages/teacher_profile/teacher_profile_from_search.dart';
import 'package:flutter/material.dart';

class TeacherResultContainer extends StatelessWidget {
  final String name;
  final String description;
  final String? picture;
  final double rating;
  final int id;

  const TeacherResultContainer({
    super.key,
    required this.name,
    required this.description,
    required this.picture,
    required this.rating,
    required this.id
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => TeacherProfileFromSearch(id: id))
            );
        },
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
                    name,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 20,
                      letterSpacing: 0,
                    ),
                  ),
                  Text(
                    "$rating/10.0",
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      letterSpacing: 0,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
