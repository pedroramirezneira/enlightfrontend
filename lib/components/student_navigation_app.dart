import 'package:enlight/pages/chats/chats.dart';
import 'package:enlight/pages/search/search.dart';
import 'package:enlight/pages/student_profile/student_profile.dart';
import 'package:flutter/material.dart';

class StudentNavigationApp extends StatefulWidget {
  const StudentNavigationApp({super.key});

  @override
  State<StudentNavigationApp> createState() => _StudentNavigationAppState();
}

class _StudentNavigationAppState extends State<StudentNavigationApp> {
  int index = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        const SearchTeachers(),
        const Chats(),
        const StudentProfile(),
      ][index],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) => setState(() => index = value),
        selectedIndex: index,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            label: "Search",
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_rounded),
            label: "Chats",
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
