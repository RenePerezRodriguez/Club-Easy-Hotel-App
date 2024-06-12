import 'package:flutter/material.dart';
import 'package:club_easy_hotel/services/api_service.dart'; // Asegúrate de usar la ruta correcta a api_service.dart
import 'package:url_launcher/url_launcher.dart';


class HotelListPage extends StatefulWidget {
  const HotelListPage({super.key});

  @override
  _HotelListPageState createState() => _HotelListPageState();
}

class _HotelListPageState extends State<HotelListPage> {
  late Future<List<Hotel>> futureHotels;
  String? selectedDepartment;

  @override
  void initState() {
    super.initState();
    futureHotels = fetchHotels();
  }

 void sendMessageToWhatsApp(String phoneNumber) async {
  const String message = "Hola le hablo desde la app de Club Easy Hotel, me gustaría obtener más información sobre el hotel.";
  final Uri whatsappUri = Uri.parse("whatsapp://send?phone=+$phoneNumber&text=${Uri.encodeFull(message)}");
  final Uri whatsappWebUri = Uri.parse("https://wa.me/$phoneNumber/?text=${Uri.encodeFull(message)}");

  if (await canLaunchUrl(whatsappUri)) {
    await launchUrl(whatsappUri);
  } else if (await canLaunchUrl(whatsappWebUri)) {
    await launchUrl(whatsappWebUri);
  } else {
    // Manejo de errores si no se puede abrir ni WhatsApp ni WhatsApp Web
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No se pudo abrir WhatsApp ni WhatsApp Web.'),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Departamento'),
        actions: <Widget>[
          DropdownButton<String>(
            value: selectedDepartment,
            onChanged: (String? newValue) {
              setState(() {
                selectedDepartment = newValue;
                futureHotels = fetchHotelsByDepartment(selectedDepartment!);
              });
            },
            items: <String>[
                            'Beni',
                            'Chuquisaca',
                            'Cochabamba',
                            'La-Paz',
                            'Oruro',
                            'Pando',
                            'Potosí',
                            'Santa-Cruz',
                            'Tarija',
                          ]
                            // Añade todos los departamentos aquí
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: FutureBuilder<List<Hotel>>(
        future: futureHotels,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Ocurrió un error al cargar los hoteles.'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Hotel hotel = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 5,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80, // Asegúrate de proporcionar un tamaño definido
                        child: Image.network(
                          hotel.thumbnail,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(hotel.title),
                              Row(
                                children: List.generate(hotel.estrellas, (index) {
                                  return const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  );
                                }),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${hotel.precioRack} ${hotel.moneda}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 14, // Tamaño más pequeño para el precio tachado
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${hotel.tarifaEasy} ${hotel.moneda}',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.secondary, // Color secundario del tema
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18, // Tamaño más grande para el precio destacado
                                  ),
                                ),
                              ),
                              const Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Tarifa Easy Hotel', // Texto adicional
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12, // Tamaño más pequeño para este texto
                                  ),
                                ),
                              ),                            ],
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: hotel.whatsapp.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.message),
                                onPressed: () => sendMessageToWhatsApp(hotel.whatsapp),
                              )
                            : IconButton(
                                icon: const Icon(Icons.message),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('No hay un número de WhatsApp disponible para este hotel.'),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            );



          } else {
            return const Center(child: Text('No hay datos disponibles.'));
          }
        },
      ),
    );
  }
}
