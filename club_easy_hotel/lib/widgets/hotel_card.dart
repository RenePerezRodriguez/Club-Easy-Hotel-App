import 'package:club_easy_hotel/models/hotel.dart';
import 'package:flutter/material.dart';
import 'package:club_easy_hotel/utils/whatsapp_messaging.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:club_easy_hotel/models/user_session.dart';
import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;

  const HotelCard({super.key, required this.hotel});

  // Función para determinar si la URL de la imagen termina en '.svg'.
    bool isSvgImage(String url) {
      return url.toLowerCase().endsWith('.svg');
    }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Provider.of<UserSession>(context).token != null;

    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            isSvgImage(hotel.thumbnail)
              ? SvgPicture.network(
                  hotel.thumbnail,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 250,
                  placeholderBuilder: (BuildContext context) => Container(
                    padding: const EdgeInsets.all(30.0),
                    child: const CircularProgressIndicator(),
                  ),
                )
              : Image.network(
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
                alignment: Alignment.centerRight,
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
                      Provider.of<UserSession>(context, listen: false).redirectToLogin(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                      side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                    ),
                    child: const Text('Reservar'),
                  ),
                  if (!Platform.isIOS)
                    OutlinedButton(
                      onPressed: () {
                        launchUrl(Uri.parse('http://admin2.easyhotel.com.bo//sessions/buy_card?redirect_to='));
                      },
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
                onPressed: () => sendMessageToWhatsApp(context, hotel.whatsapp, "Hola, soy miembro del Club EasyHotel y me encantaría realizar una reserva en su hotel."),
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
  }
}
