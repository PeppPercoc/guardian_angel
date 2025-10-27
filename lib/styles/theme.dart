import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFFB71C1C);
  static const secondary = Color(0xFF388E3C);
  static const background = Color(0xFFD0EEC8);
  static const textDark = Color(0xFF263238);
}

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.background,
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
