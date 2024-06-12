import 'package:club_easy_hotel/main.dart';
import 'package:club_easy_hotel/models/user_session.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Usa Provider para obtener la información de la sesión del usuario
    final userSession = Provider.of<UserSession>(context);
    final bool isLoggedIn = userSession.token != null; // Verifica si el usuario está logueado
    final String? name = userSession.userName; // Obtiene el nombre del usuario de la sesión

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.network(
            'http://easyhotel.com.bo/wp-content/uploads/2024/03/sasha-kaunas-TAgGZWz6Qg8-unsplash-scaled.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5), // Añade una capa de opacidad
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    isLoggedIn ? '¡Buenos días, $name!' : 'Las mejores tarifas en los mejores hoteles',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 90.0, horizontal: 20.0),
                  child: Text(
                    isLoggedIn ? 'Disfruta de tu estadía con nosotros.' : 'Si perteneces al Club Easy Hotel obtendrás las mejores tarifas para tu alojamiento.',
                    style: const TextStyle(fontSize: 18, color: Colors.white70),
                    textAlign: TextAlign.start,
                  ),
                ),
                if (!isLoggedIn) // Muestra el botón solo si el usuario no está logueado
                  ElevatedButton(
                    onPressed: () {
                      // Usa la función selectPage de MyHomePage para cambiar la página
                      MyHomePage.selectPage(context, 2); // Asumiendo que el índice 2 es para LoginPage
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary, // Color de fondo del botón
                      foregroundColor: Colors.white, // Asegura que el texto sea blanco para mayor contraste
                    ),
                    child: const Text(
                      'Comprar Membresia',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                if (isLoggedIn) // Si el usuario está logueado, muestra un botón personalizado o no muestres nada
                  // Aquí puedes agregar un botón personalizado o simplemente no mostrar nada
                TextButton(
                  onPressed: () {
                    // Lógica para este texto
                  },
                  child: const Text(
                    '¿Algo no funciona bien? Consulta',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
