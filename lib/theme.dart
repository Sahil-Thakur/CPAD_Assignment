import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.teal,
    primary: Colors.teal,
    secondary: Colors.orangeAccent,
  ),
  scaffoldBackgroundColor: const Color(0xFFF6F6F6),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.teal,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black87),
    bodyMedium: TextStyle(color: Colors.black87),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    primary: Colors.deepPurple,
    secondary: Colors.pinkAccent,
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.deepPurple,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF1E1E1E),
    border: OutlineInputBorder(),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
    ),
  ),
);
