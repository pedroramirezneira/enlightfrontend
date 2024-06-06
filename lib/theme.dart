import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: const Color.fromARGB(255, 43, 57, 68),
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
    surface: const Color.fromARGB(255, 43, 57, 68),
    onSurface: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      fixedSize: const WidgetStatePropertyAll(
        Size(double.maxFinite, 50),
      ),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
      backgroundColor:
          const WidgetStatePropertyAll(Color.fromARGB(255, 100, 201, 169)),
      foregroundColor: const WidgetStatePropertyAll(Colors.white),
      overlayColor: WidgetStatePropertyAll(Colors.white.withOpacity(0.11)),
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
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: Color.fromARGB(255, 49, 54, 63),
    indicatorColor: Color.fromARGB(255, 100, 201, 169),
    labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
  ),
);
