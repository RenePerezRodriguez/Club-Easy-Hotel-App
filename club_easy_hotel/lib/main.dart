import 'package:club_easy_hotel/screens/login_page.dart';
import 'package:club_easy_hotel/models/user_session.dart';
import 'package:club_easy_hotel/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'themes/theme.dart';
import 'screens/home_page.dart';
import 'screens/hotel_list_page.dart';
import 'screens/web_view_page.dart';
import 'routes.dart';
import 'services/location_manager.dart';

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
    final locationManager = LocationManager();
    return MaterialApp(
      title: 'Club Easy Hotel',
      routes: appRoutes,
      theme: darkTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      home: FutureBuilder(
        future: locationManager.determinePosition(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final position = snapshot.data as Position;
              if (position.latitude >= -23.0 && position.latitude <= -9.0 &&
                  position.longitude >= -69.0 && position.longitude <= -57.5) {
                return const MyHomePage();
              } else {
                return const WebViewPage();
              }
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No se pudo obtener la ubicación'),
                    ElevatedButton(
                      onPressed: () {
                        // Reintentar obtener la ubicación
                        locationManager.determinePosition();
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Esperando la ubicación...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
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
    const HomePage(),
    const HotelListPage(),
    const LoginPage(),
    // Añade tus otras pantallas aquí
  ];

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }


  void _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      // Solicitamos el permiso
      if (await Permission.location.request().isGranted) {
        // El permiso fue concedido
      } else {
        // El permiso fue denegado, mostramos un diálogo
        _showPermissionDialog();
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permiso de Ubicación Requerido'),
          content: const Text('Esta aplicación necesita acceso a tu ubicación para funcionar correctamente.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Abrir Configuración'),
              onPressed: () {
                openAppSettings(); // Abre la configuración de la aplicación
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    // Usa Provider para obtener la información de la sesión del usuario
    final userSession = Provider.of<UserSession>(context);
    final String? token = userSession.token; // Obtiene el token de la sesión
    final String? name = userSession.userName; // Obtiene el nombre del usuario de la sesión

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Color de fondo del AppBar
        leading: IconButton(
          icon: Image.network('http://easyhotel.com.bo/wp-content/uploads/2024/03/cropped-logo-2-fondo-1.png'),
          onPressed: () {
            // Acción al presionar el ícono
          },
        ),
        title: Text(
          name ?? 'Club Easy Hotel', // Muestra el token si está disponible, de lo contrario muestra el título por defecto
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WebViewPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD3A75B), // Color de fondo del botón (dorado)
              ),
              child: const Text(
                'Internacional',
                style: TextStyle(
                  color: Colors.white, // Color del texto del botón
                ),
              ),
            ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
      selectedIndex: _selectedIndex,
      onItemTapped: _onItemTapped,
    ),
    );
  }
}
