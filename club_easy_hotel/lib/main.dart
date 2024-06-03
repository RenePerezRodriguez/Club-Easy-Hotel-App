import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'themes/theme.dart';
import 'services/location_service.dart';
import 'screens/home_page.dart';
import 'screens/hotel_list_page.dart';
import 'screens/web_view_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Club Easy Hotel',
          routes: {
            '/home': (context) => HomePage(),
            '/hotelList': (context) => HotelListPage(),
            '/webView': (context) => WebViewPage(),
            // Define más rutas según sea necesario
          },
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: currentMode,
          home: FutureBuilder<Position>(
            future: determinePosition(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  // Si la ubicación es Bolivia, muestra MyHomePage
                  if (snapshot.data!.latitude >= -23.0 && snapshot.data!.latitude <= -9.0 &&
                      snapshot.data!.longitude >= -69.0 && snapshot.data!.longitude <= -57.5) {
                    return MyHomePage(themeNotifier: themeNotifier);
                  } else {
                    // Si no, muestra WebViewPage
                    return const WebViewPage();
                  }
                } else {
                  // Manejo de errores o estado sin datos
                  return const Center(child: Text('No se pudo obtener la ubicación'));
                }
              } else {
                // Muestra un indicador de carga mientras espera
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          
        );
      },
    );
  }

  
}

class MyHomePage extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeNotifier;

  const MyHomePage({super.key, required this.themeNotifier});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const HotelListPage(),
    // Añade tus otras pantallas aquí
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
      backgroundColor: Colors.black, // Color de fondo del AppBar
      leading: IconButton(
        icon: Image.network('http://easyhotel.com.bo/wp-content/uploads/2024/03/cropped-logo-2-fondo-1.png'),
        onPressed: () {
          // Acción al presionar el ícono
        },
      ),
      title: const Text(
        'Club Easy Hotel',
        style: TextStyle(
          color: Colors.white, // Color del título
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
            'Reservar',
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hotel),
            label: 'Hoteles',
          ),
          // Añade más ítems aquí para tus otras pantallas
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.brightness_4),
        onPressed: () {
          widget.themeNotifier.value = (widget.themeNotifier.value == ThemeMode.light)
              ? ThemeMode.dark
              : ThemeMode.light;
        },
      ),
    );
  }
}


