import 'package:enlight/components/student_navigation_app.dart';
import 'package:enlight/components/teacher_navigation_app.dart';
import 'package:enlight/firebase_options.dart';
import 'package:enlight/pages/sign_in/sign_in.dart';
import 'package:enlight/services/account_service.dart';
import 'package:enlight/services/auth_service.dart';
import 'package:enlight/services/messaging_service.dart';
import 'package:enlight/services/reservation_service.dart';
import 'package:enlight/services/teacher_service.dart';
import 'package:enlight/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<void> main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.requestPermission();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthServiceProvider(
      serverAddress: dotenv.env["SERVER"]!,
      child: const _MyApp(),
    );
  }
}

class _MyApp extends StatelessWidget {
  const _MyApp();

  @override
  Widget build(BuildContext context) {
    final authService = AuthService.of(context);

    if (authService.accessToken == AuthService.emptyToken ||
        authService.refreshToken == AuthService.emptyToken) {
      return MaterialApp(
        title: "Enlight",
        theme: theme,
        home: const SignIn(),
        debugShowCheckedModeBanner: false,
      );
    }

    final Widget home;

    switch (authService.role) {
      case 1:
        home = const StudentNavigationApp();
        break;
      case 2:
        home = const TeacherNavigationApp();
        break;
      default:
        home = const SignIn();
        break;
    }

    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<MessagingService>(
          create: (context) => MessagingService(context: context),
        ),
        ChangeNotifierProvider<ReservationService>(
          create: (context) => ReservationService(context: context),
        ),
        ChangeNotifierProvider<AccountService>(
          create: (context) => AccountService(context: context),
        ),
        ChangeNotifierProvider(
          create: (context) => TeacherService(context: context),
        ),
      ],
      child: MaterialApp(
        title: "Enlight",
        theme: theme,
        home: home,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
