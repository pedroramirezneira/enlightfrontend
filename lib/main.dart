import 'package:enlight/pages/sign_in.dart';
import 'package:enlight/util/token.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  final token = await Token.getToken();
  if (token == null) {
    runApp(const MyApp(
      home: SignIn(),
    ));
    return;
  }
  final valid = await Token.verifyToken(token);
  valid
      ? runApp(const MyApp(
          home: Placeholder(),
        ))
      : runApp(const MyApp(
          home: SignIn(),
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
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 100, 201, 169),
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
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
          backgroundColor: Color.fromARGB(255, 100, 201, 169),
          contentTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: home,
    );
  }
}
