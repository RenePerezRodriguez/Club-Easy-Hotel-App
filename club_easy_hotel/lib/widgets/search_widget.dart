import 'package:club_easy_hotel/models/user_session.dart';
import 'package:flutter/material.dart';
import 'package:club_easy_hotel/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchWidget extends StatefulWidget {
  final Function(List<Hotel>) onSearchResults;

  const SearchWidget({super.key, required this.onSearchResults});

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchHotels(String query) async {
    if (query.isEmpty) {
      return;
    }
    try {
      List<Hotel> hotels = await fetchHotels();
      List<Hotel> searchResults = hotels.where((hotel) {
        return hotel.title.toLowerCase().contains(query.toLowerCase());
      }).toList();

      widget.onSearchResults(searchResults);
    } catch (e) {
      print('Error al buscar hoteles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(255, 60, 59, 59),
        hintText: 'Busca tu hotel',
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => _searchHotels(_searchController.text),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

void sendMessageToWhatsApp(BuildContext context, String phoneNumber) async {
    const String message = "Hola le hablo desde la app de Club Easy Hotel, me gustaría obtener más información sobre el hotel.";
    final Uri whatsappUri = Uri.parse("whatsapp://send?phone=+$phoneNumber&text=${Uri.encodeFull(message)}");
    final Uri whatsappWebUri = Uri.parse("https://wa.me/$phoneNumber/?text=${Uri.encodeFull(message)}");

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else if (await canLaunchUrl(whatsappWebUri)) {
      await launchUrl(whatsappWebUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo abrir WhatsApp ni WhatsApp Web.'),
        ),
      );
    }
  }

class SearchResultsPage extends StatelessWidget {
  final List<Hotel> searchResults;

  const SearchResultsPage({super.key, required this.searchResults});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Provider.of<UserSession>(context).token != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados de Búsqueda'),
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final hotel = searchResults[index];
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.network(
                                  hotel.thumbnail,
                                  fit: BoxFit.cover, 
                                  width: double.infinity, 
                                  height: 250, 
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  hotel.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(hotel.estrellas, (index) {
                                    return const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    );
                                  }),
                                ),
                                Text(
                                  hotel.direccion,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                if (hotel.precioRack.isNotEmpty && hotel.moneda.isNotEmpty) ...[
                                  Text(
                                    'Precio rack: ${hotel.precioRack} ${hotel.moneda}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                                if (hotel.tarifaEasy.isNotEmpty && hotel.moneda.isNotEmpty) ...[
                                  Text(
                                    'Precio: ${hotel.tarifaEasy} ${hotel.moneda} por noche',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 10),
                                if (!isLoggedIn) ...[
                                  const Text(
                                    'Inicia sesión o compra una membresía para reservar con descuento',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Provider.of<UserSession>(context, listen: false).redirectToLogin(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Theme.of(context).primaryColor, 
                                      side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                                    ),
                                    child: const Text('Iniciar sesión / Comprar membresía'),
                                  ),
                                ] else if (hotel.whatsapp.isNotEmpty) ...[
                                  ElevatedButton(
                                    onPressed: () => sendMessageToWhatsApp(context, hotel.whatsapp),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Theme.of(context).primaryColor, 
                                      backgroundColor: Colors.white,
                                      side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                                    ),
                                    child: const Text('Reservar'),
                                  ),
                                ] else ...[
                                  const Text(
                                    'Muy pronto',
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            )
    );
  }
}
