import 'package:enlight/pages/sign_in/sign_in.dart';
import 'package:enlight/pages/student_profile/student_profile.dart';
import 'package:enlight/pages/teacher_profile/teacher_profile.dart';
import 'package:enlight/theme.dart';
import 'package:enlight/util/io.dart';
import 'package:enlight/util/token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  final accessToken = await Token.getAccessToken();
  final refreshToken = await Token.getRefreshToken();
  final role = await IO.getRole();
  if (refreshToken == null) {
    runApp(const MyApp(
      home: SignIn(),
    ));
    return;
  }
  final valid = await Token.verifyAccessToken(accessToken!);
  if (!valid) {
    await Token.refreshAccessToken();
  }
  runApp(MyApp(
    home: switch (role ?? "") {
      "teacher" => const TeacherProfile(),
      "student" => const StudentProfile(),
      String() => const SignIn(),
    },
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
    );
  }
}
