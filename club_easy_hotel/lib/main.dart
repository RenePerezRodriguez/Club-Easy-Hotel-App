import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:club_easy_hotel/models/user_session.dart';
import 'package:club_easy_hotel/screens/home_page.dart';
import 'package:club_easy_hotel/screens/hotel_list_page.dart';
import 'package:club_easy_hotel/screens/login_page.dart';
import 'package:club_easy_hotel/widgets/custom_bottom_navigation_bar.dart';
import 'package:club_easy_hotel/themes/theme.dart';
import 'package:club_easy_hotel/routes.dart';

/// Punto de entrada principal de la aplicación.
void main() {
  runApp(
    // Envuelve la aplicación con el Provider para manejar el estado de la sesión del usuario.
    ChangeNotifierProvider(
      create: (context) => UserSession(),
      child: const MyApp(),
    ),
  );
}

/// Widget principal de la aplicación que define la configuración global.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Club Easy Hotel',
      // Define las rutas nombradas para la navegación en la aplicación.
      routes: appRoutes,
      // Aplica el tema oscuro definido en 'theme.dart'.
      darkTheme: darkTheme,
      // Establece el modo del tema en oscuro.
      themeMode: ThemeMode.dark,
      // Establece la página de inicio de la aplicación.
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Widget de la página de inicio que contiene la navegación principal.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

/// Estado del widget MyHomePage que maneja la selección de la página actual.
class MyHomePageState extends State<MyHomePage> {
  // Índice de la página seleccionada actualmente en la barra de navegación.
  int _selectedIndex = 0;

  // Lista de widgets para mostrar en el cuerpo de Scaffold basado en la selección de la barra de navegación.
  final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    const HotelListPage(),
    const LoginPage(),
    // Añade tus otras pantallas aquí.
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Muestra el widget seleccionado en el cuerpo de Scaffold.
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      // Barra de navegación personalizada para cambiar entre páginas.
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        // Verifica si el usuario está conectado para actualizar la interfaz de usuario.
        isUserLoggedIn: Provider.of<UserSession>(context).token != null,
      ),
    );
  }

  /// Actualiza el índice seleccionado y reconstruye el widget para mostrar la nueva página.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
