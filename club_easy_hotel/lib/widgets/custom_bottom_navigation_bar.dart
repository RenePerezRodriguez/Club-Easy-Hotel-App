import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final bool isUserLoggedIn; // Añade este parámetro

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.isUserLoggedIn, // Añade este parámetro
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.hotel),
          label: 'Hoteles',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: isUserLoggedIn ? 'Membresía' : 'Membresía', // Cambia la etiqueta según el estado de la sesión
        ),
        // Añade más ítems aquí para tus otras pantallas
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
    );
  }
}
