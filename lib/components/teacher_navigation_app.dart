import 'package:enlight/pages/chats/chats.dart';
import 'package:enlight/pages/teacher_profile/teacher_profile.dart';
import 'package:enlight/pages/reservations/reservations.dart';
import 'package:enlight/services/messaging_service.dart';
import 'package:enlight/services/reservation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

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
        const Reservations(),
        const TeacherProfile(),
      ][index],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) {
          setState(() => index = value);
          if (index == 1) {
            try {
              context.read<ReservationService>().readReservations();
            } catch (error) {
              null;
            }
          }
        },
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
          NavigationDestination(
            icon: Consumer<ReservationService>(
              builder: (context, value, child) => badges.Badge(
                badgeContent: Text(value.newReservations.toString()),
                showBadge: value.newReservations > 0,
                child: const Icon(Icons.bookmark_rounded),
              ),
            ),
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
