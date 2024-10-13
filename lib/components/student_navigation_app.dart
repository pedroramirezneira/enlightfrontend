import 'package:badges/badges.dart' as badges;
import 'package:enlight/pages/chats/chats.dart';
import 'package:enlight/pages/reservations/reservations.dart';
import 'package:enlight/pages/search/search.dart';
import 'package:enlight/pages/student_profile/student_profile.dart';
import 'package:enlight/services/messaging_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentNavigationApp extends StatefulWidget {
  const StudentNavigationApp({super.key});

  @override
  State<StudentNavigationApp> createState() => _StudentNavigationAppState();
}

class _StudentNavigationAppState extends State<StudentNavigationApp> {
  int index = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        const Chats(),
        const SearchTeachers(),
        const Reservations(),
        const StudentProfile(),
      ][index],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) => setState(() => index = value),
        selectedIndex: index,
        destinations: <Widget>[
          NavigationDestination(
            icon: Consumer<MessagingService>(
              builder: (context, value, child) => badges.Badge(
                badgeContent: Text(value.newMessages.toString()),
                showBadge: value.newMessages > 0,
                child: const Icon(Icons.chat_rounded),
              ),
            ),
            label: "Chats",
          ),
          const NavigationDestination(
            icon: Icon(Icons.search_rounded),
            label: "Search",
          ),
          const NavigationDestination(
            icon: Icon(Icons.bookmark_rounded),
            label: "Reservations",
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_rounded),
            label: "Account",
          ),
        ],
      ),
    );
  }
}
