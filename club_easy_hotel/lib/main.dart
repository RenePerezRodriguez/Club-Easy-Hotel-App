import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:club_easy_hotel/models/user_session.dart';
import 'package:club_easy_hotel/screens/home_page.dart';
import 'package:club_easy_hotel/screens/hotel_list_page.dart';
import 'package:club_easy_hotel/screens/login_page.dart';
import 'package:club_easy_hotel/widgets/custom_bottom_navigation_bar.dart';
import 'package:club_easy_hotel/themes/theme.dart';
import 'package:club_easy_hotel/routes.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserSession(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Club Easy Hotel',
      routes: appRoutes,
      theme: darkTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();

  // Agrega esta función pública para cambiar de página
  static void selectPage(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<MyHomePageState>();
    state?.selectPage(index);
  }
}

class MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _widgetOptions = <Widget>[
     HomePage(),
    const HotelListPage(),
    const LoginPage(),
    // Añade tus otras pantallas aquí
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        isUserLoggedIn: Provider.of<UserSession>(context).token != null, // Esto verificará si el token de sesión está presente
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
