import 'package:app_links/app_links.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:badges/badges.dart' as badges;
import 'package:enlight/pages/chats/chats.dart';
import 'package:enlight/pages/reservations/reservations.dart';
import 'package:enlight/pages/search/search.dart';
import 'package:enlight/pages/student_profile/student_profile.dart';
import 'package:enlight/services/messaging_service.dart';
import 'package:enlight/services/reservation_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentNavigationApp extends StatefulWidget {
  const StudentNavigationApp({super.key});

  @override
  State<StudentNavigationApp> createState() => _StudentNavigationAppState();
}

class _StudentNavigationAppState extends State<StudentNavigationApp> {
  int index = 3;
  late AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.requestPermission();
    _initAppLinks(context);
  }

  void _initAppLinks(BuildContext context) async {
    _appLinks = AppLinks();
    final Uri? initialLink = await _appLinks.getInitialLink();
    if (!context.mounted) return;
    if (initialLink != null) {
      _handleDeepLink(context, initialLink);
    }

    _appLinks.uriLinkStream.listen(
      (Uri uri) {
        if (!context.mounted) return;
        _handleDeepLink(context, uri);
      },
      onError: (err) {
        debugPrint('Failed to process deep link: $err');
      },
    );
  }

  void _handleDeepLink(BuildContext context, Uri uri) {
    debugPrint("Deep link: $uri");
    if (uri.path.contains("/success")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: AwesomeSnackbarContent(
            title: "Success",
            message: "Your payment was successful",
            contentType: ContentType.success,
          ),
          duration: Duration(seconds: 5),
        ),
      );
    }
    if (uri.path.contains("/failure")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: AwesomeSnackbarContent(
            title: "Error",
            message: "Your payment was unsuccessful",
            contentType: ContentType.failure,
          ),
          duration: Duration(seconds: 5),
        ),
      );
    }
    if (uri.path.contains("/pending")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: AwesomeSnackbarContent(
            title: "Warning",
            message: "Your payment is pending",
            contentType: ContentType.help,
          ),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final reservationService = Provider.of<ReservationService>(context);
    return Scaffold(
      body: <Widget>[
        const Chats(),
        const SearchTeachers(),
        const Reservations(),
        const StudentProfile(),
      ][index],
      bottomNavigationBar: NavigationBar(
        height: 60,
        onDestinationSelected: (value) {
          setState(() => index = value);
          if (index == 2) {
            reservationService.readReservations();
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
          const NavigationDestination(
            icon: Icon(Icons.search_rounded),
            label: "Search",
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
