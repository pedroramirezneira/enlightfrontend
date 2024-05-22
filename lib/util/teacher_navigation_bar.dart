import 'package:enlight/pages/teacher_profile/teacher_profile.dart';
import 'package:enlight/pages/teacher_profile/teacher_reservation.dart';
import 'package:flutter/material.dart';

class TeacherNavigationBar extends StatelessWidget {
  final int index;

  const TeacherNavigationBar({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.bookmark),
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
          case 0:
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const TeacherReservations()),
              (route) => false,
            );
            break;
          case 1:
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const TeacherProfile()),
              (route) => false,
            );
            break;

          default:
        }
      },
      backgroundColor: const Color.fromARGB(255, 43, 57, 68),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: false,
    );
  }
}
