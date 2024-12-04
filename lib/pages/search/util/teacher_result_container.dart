import 'dart:convert';

import 'package:enlight/pages/teacher_profile/teacher_profile_from_search.dart';
import 'package:flutter/material.dart';

class TeacherResultContainer extends StatelessWidget {
  final String name;
  final String description;
  final String? picture;
  final num rating;
  final int id;

  const TeacherResultContainer({
    super.key,
    required this.name,
    required this.description,
    required this.picture,
    required this.rating,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TeacherProfileFromSearch(id: id),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 71, 129, 118),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.surface.withOpacity(0.5),
                  radius: 35,
                  backgroundImage: MemoryImage(base64.decode(picture ?? "")),
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "${rating.toStringAsFixed(1)}/10.0",
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              description,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
