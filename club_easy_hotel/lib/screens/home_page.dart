import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'Las mejores tarifas en los mejores hoteles',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.start,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 90.0, horizontal: 20.0),
                  child: Text(
                    'Si perteneces al Club Easy Hotel obtendrás las mejores tarifas para tu alojamiento.',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                    textAlign: TextAlign.start,
                  ),
                ),
                 ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login'); // Navega a LoginPage
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary, // Color de fondo del botón
                  ),
                  child: Text(
                    'Comprar Membresia',
                    style: TextStyle(fontSize: 18, color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                ),
                TextButton(
                  onPressed: () { /* logica para este texto */},
                  child: const Text(
                    '¿Ya Estas Registrado? Consulta',
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
