import 'package:flutter/material.dart';

class AppTheme {
  static const bbkSeed = Color(0xFF123D7A);
  static const scaffold = Color(0xFFF8F2FF);

  static ThemeData get theme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: bbkSeed,
          primary: bbkSeed,
          secondary: const Color(0xFF355EA6),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: bbkSeed,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        scaffoldBackgroundColor: scaffold,
        useMaterial3: true,
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: bbkSeed,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFCAD6F4),
          foregroundColor: Colors.black87,
        ),
      );
}
