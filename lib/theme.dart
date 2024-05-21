import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
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
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      fixedSize: const MaterialStatePropertyAll(
        Size(double.maxFinite, 50),
      ),
      shape: const MaterialStatePropertyAll(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
      backgroundColor:
          const MaterialStatePropertyAll(Color.fromARGB(255, 100, 201, 169)),
      foregroundColor: const MaterialStatePropertyAll(Colors.white),
      overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.11)),
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
  timePickerTheme: const TimePickerThemeData(
    backgroundColor: Color.fromARGB(255, 43, 57, 68),
    hourMinuteColor: Colors.grey,
    dialBackgroundColor: Colors.grey,
    dialHandColor: Color.fromARGB(255, 100, 201, 169),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color.fromARGB(255, 43, 57, 68),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromARGB(255, 100, 201, 169),
    shape: CircleBorder(),
  ),
);
