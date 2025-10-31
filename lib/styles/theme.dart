import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color.fromARGB(255, 183, 28, 28);
  static const secondary = Color.fromARGB(255, 56, 142, 60);
  static const backgroundSecondary = Color.fromARGB(255, 208, 238, 200);
  static const backgroundPrimary = Color.fromARGB(255, 255, 226, 226);
  static const textDark = Color.fromARGB(255, 38, 50, 56);
}

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.backgroundSecondary,
  fontFamily: 'Roboto',
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 18, color: AppColors.textDark),
    titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
    labelLarge: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.white,
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.secondary,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Colors.white,
    ),
    centerTitle: true,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.secondary,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: AppColors.secondary,
    unselectedItemColor: Colors.grey,
    backgroundColor: Color(0xFFF7F7F7),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.grey),
    hintStyle: TextStyle(color: Colors.grey),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.secondary,
        width: 2,
      ),
    ),
  ),
);
