import 'package:enlight/pages/sign_in.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enlight',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
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
          background: Colors.blue.shade900,
          onBackground: Colors.white,
          surface: Colors.blue,
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
            backgroundColor: MaterialStatePropertyAll(Colors.blue),
            foregroundColor: MaterialStatePropertyAll(Colors.white),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Colors.blue,
          contentTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: const SignIn(),
    );
  }
}
