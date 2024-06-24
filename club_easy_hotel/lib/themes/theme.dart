import 'package:flutter/material.dart';

// Importa tus otras pantallas aquí
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFFD3A75B),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color(0xFFFFFFFF),
    selectedItemColor: const Color(0xFFD3A75B),
    unselectedItemColor: const Color(0xFF1A1A1A).withOpacity(0.5),
  ),
  colorScheme: const ColorScheme.light().copyWith(
    primary: const Color(0xFFD3A75B),
    secondary: const Color(0xFFD3A75B),
  ),
  // Otros componentes de la interfaz de usuario
  // ...
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFFD3A75B),
  scaffoldBackgroundColor: const Color(0xFF1A1A1A),
  
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color(0xFF1A1A1A),
    selectedItemColor: const Color(0xFFD3A75B),
    unselectedItemColor: const Color(0xFFD3A75B).withOpacity(0.5),
  ),
  colorScheme: const ColorScheme.dark().copyWith(
    primary: const Color(0xFFD3A75B),
    secondary: const Color(0xFFD3A75B),
  ),
  // Otros componentes de la interfaz de usuario
  // ...
);
