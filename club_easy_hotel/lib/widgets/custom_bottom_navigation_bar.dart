// custom_bottom_navigation_bar.dart
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.hotel),
          label: 'Hoteles',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil de usuario',
        ),
        // Añade más ítems aquí para tus otras pantallas
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
    );
  }
}
