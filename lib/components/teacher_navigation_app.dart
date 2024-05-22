import 'package:enlight/pages/chats/chats.dart';
import 'package:enlight/pages/teacher_profile/teacher_profile.dart';
import 'package:enlight/pages/teacher_profile/teacher_reservation.dart';
import 'package:flutter/material.dart';

class TeacherNavigationApp extends StatefulWidget {
  const TeacherNavigationApp({super.key});

  @override
  State<TeacherNavigationApp> createState() => _TeacherNavigationAppState();
}

class _TeacherNavigationAppState extends State<TeacherNavigationApp> {
  int index = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        const Chats(),
        const TeacherReservations(),
        const TeacherProfile(),
      ][index],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) => setState(() => index = value),
        selectedIndex: index,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.chat_rounded),
            label: "Chats",
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_rounded),
            label: "Reservations",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_rounded),
            label: "Account",
          ),
        ],
      ),
    );
  }
}
