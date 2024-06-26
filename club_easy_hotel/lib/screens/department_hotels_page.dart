import 'package:flutter/material.dart';
import 'package:club_easy_hotel/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:club_easy_hotel/models/user_session.dart';

class DepartmentHotelsPage extends StatelessWidget {
  final String department;

  const DepartmentHotelsPage({super.key, required this.department});

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

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Provider.of<UserSession>(context).token != null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hoteles en $department'),
      ),
      body: FutureBuilder<List<Hotel>>(
        future: fetchHotelsByDepartment(department),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Hotel hotel = snapshot.data![index];
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
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Precio rack: ${hotel.precioRack} ${hotel.moneda}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                              if (hotel.tarifaEasy.isNotEmpty && hotel.moneda.isNotEmpty) ...[
                                Align(
                                  alignment: Alignment.centerRight, // Alinea el texto a la derecha
                                  child: Text(
                                    'Precio: ${hotel.tarifaEasy} ${hotel.moneda} por noche',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                                const SizedBox(height: 10),
                                if (!isLoggedIn) ...[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {
                                          // Acción para el botón de reservar
                                          Provider.of<UserSession>(context, listen: false).redirectToLogin(context);
                                        },
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Theme.of(context).primaryColor,
                                          side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                                        ),
                                        child: const Text('Reservar'),
                                      ),
                                      OutlinedButton(
                                        onPressed: () {
                                        // Reemplaza con el enlace al que quieres que lleve el botón
                                        launchUrl(Uri.parse('http://admin2.easyhotel.com.bo//sessions/buy_card?redirect_to='));                                        },
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Theme.of(context).primaryColor,
                                          side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                                        ),
                                        child: const Text('Comprar membresía'),
                                      ),
                                    ],
                                  ),
                                ] else if (hotel.whatsapp.isNotEmpty) ...[
                                  OutlinedButton(
                                    onPressed: () => sendMessageToWhatsApp(context, hotel.whatsapp),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Theme.of(context).primaryColor,
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
                    );
          } else {
            return Center(child: Text('No hay hoteles disponibles para el departamento $department'));
          }
        },
      ),
    );
  }
}
