import 'package:enlight/pages/sign_in.dart';
import 'package:enlight/pages/student_profile.dart';
import 'package:enlight/pages/teacher_profile.dart';
import 'package:enlight/util/io.dart';
import 'package:enlight/util/token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

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
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 43, 57, 68),
          centerTitle: true,
          titleTextStyle: GoogleFonts.getFont(
            "Montserrat",
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        fontFamily: GoogleFonts.montserrat().fontFamily,
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.purple.shade100,
          onPrimary: Colors.white,
          secondary: Colors.blueAccent.shade100,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          background: const Color.fromARGB(255, 43, 57, 68),
          onBackground: Colors.white,
          surface: const Color.fromARGB(255, 100, 201, 169),
          onSurface: Colors.white,
        ),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            fixedSize: MaterialStatePropertyAll(
              Size(double.maxFinite, 50),
            ),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
            backgroundColor:
                MaterialStatePropertyAll(Color.fromARGB(255, 100, 201, 169)),
            foregroundColor: MaterialStatePropertyAll(Colors.white),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Color.fromARGB(255, 43, 57, 68),
        ),
        datePickerTheme: const DatePickerThemeData(
          backgroundColor: Color.fromARGB(255, 43, 57, 68),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color.fromARGB(255, 43, 57, 68),
        ),
      ),
      home: home,
    );
  }
}
