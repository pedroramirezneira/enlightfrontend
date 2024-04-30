import 'package:enlight/pages/search/search.dart';
import 'package:enlight/pages/student_profile/student_profile.dart';
import 'package:flutter/material.dart';

class StudentNavigationBar extends StatelessWidget {
  final int index;

  const StudentNavigationBar({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: '',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        label: '',
      ),
    ];

    return BottomNavigationBar(
      items: items,
      currentIndex: index,
      onTap: (int newIndex) {
        if (newIndex == index) {
          return;
        }
        switch (newIndex) {
          case 1:
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const StudentProfile()),
              (route) => false,
            );
            break;
          case 0:
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const SearchTeachers()),
              (route) => false,
            );
            break;
          default:
            print("Invalid navigation index: $newIndex");
        }
      },
      backgroundColor: const Color.fromARGB(255, 43, 57, 68),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: false,
    );
  }
}
