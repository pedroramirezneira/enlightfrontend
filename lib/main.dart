import 'package:enlight/components/student_navigation_app.dart';
import 'package:enlight/components/teacher_navigation_app.dart';
import 'package:enlight/firebase_options.dart';
import 'package:enlight/models/chats_data.dart';
import 'package:enlight/pages/sign_in/sign_in.dart';
import 'package:enlight/services/messaging_service.dart';
import 'package:enlight/services/reservation_service.dart';
import 'package:enlight/theme.dart';
import 'package:enlight/util/chat_ops.dart';
import 'package:enlight/util/io.dart';
import 'package:enlight/util/token.dart';
import 'package:firebase_core/firebase_core.dart';
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
  // await MessagingHandler.initializePlugin();
  // FirebaseMessaging.onBackgroundMessage(MessagingHandler.handler);
  final accessToken = await Token.getAccessToken();
  final refreshToken = await Token.getRefreshToken();
  final role = await IO.getRole();
  if (refreshToken == null) {
    runApp(MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<MessagingService>(
          create: (context) => MessagingService(),
        ),
        FutureProvider<ChatsData>(
          create: (context) => ChatOps.getChats(),
          initialData: EmptyChatsData(),
        ),
        ChangeNotifierProvider<ReservationService>(
          create: (context) => ReservationService(),
        ),
      ],
      child: MyApp(
        home: switch (role ?? "") {
          "teacher" => const TeacherNavigationApp(),
          "student" => const StudentNavigationApp(),
          String() => const SignIn(),
        },
      ),
    ));
    return;
  }
  final valid = await Token.verifyAccessToken(accessToken!);
  if (!valid) {
    await Token.refreshAccessToken();
  }
  runApp(MultiProvider(
    providers: <SingleChildWidget>[
      ChangeNotifierProvider<MessagingService>(
        create: (context) => MessagingService(),
      ),
      FutureProvider<ChatsData>(
        create: (context) => ChatOps.getChats(),
        initialData: EmptyChatsData(),
      ),
      ChangeNotifierProvider<ReservationService>(
        create: (context) => ReservationService(),
      ),
    ],
    child: MyApp(
      home: switch (role ?? "") {
        "teacher" => const TeacherNavigationApp(),
        "student" => const StudentNavigationApp(),
        String() => const SignIn(),
      },
    ),
  ));
}

class MyApp extends StatelessWidget {
  final Widget home;

  const MyApp({
    super.key,
    required this.home,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enlight',
      theme: theme,
      home: home,
      debugShowCheckedModeBanner: false,
    );
  }
}
