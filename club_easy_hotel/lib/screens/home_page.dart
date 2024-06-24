import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:club_easy_hotel/models/user_session.dart';
import 'package:club_easy_hotel/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final List<String> departments = [
    'Cochabamba',
    'La-Paz',
    'Santa-Cruz',
    'Tarija',
    'Potosí',
    'Chuquisaca',
    'Oruro',
    'Pando',
    'Beni',
  ];

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);
    final bool isLoggedIn = userSession.token != null;
    final String? name = userSession.userName;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        color: Colors.black, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 60),
            Row(
              children: [
                Image.network(
                  'https://easyhotel.com.bo/wp-content/uploads/2024/03/logo-2-fondo-1.png',
                  width: 50,
                ),
                SizedBox(width: 10), 
                Text(
                  'Club Easy Hotel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '¡Bienvenido, ',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: '${name ?? "invitado"}', 
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor, 
                    ),
                  ),
                  TextSpan(
                    text: '!', 
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Las mejores tarifas en los mejores hoteles',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7), 
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 60, 59, 59), 
                hintText: 'Hotel',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    // Implementa tu funcionalidad de búsqueda
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  'Departamentos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Selecciona un departamento para ver los hoteles disponibles',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),

            // Lista de departamentos
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: departments.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DepartmentHotelsPage(department: departments[index]),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.grey[1000], 
                      child: Center(
                        child: Text(
                          departments[index],
                          style: TextStyle(
                            color: Theme.of(context).primaryColor, 
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DepartmentHotelsPage extends StatelessWidget {
  final String department;

  DepartmentHotelsPage({Key? key, required this.department}) : super(key: key);

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Hoteles en $department'),
      ),
      body: FutureBuilder<List<Hotel>>(
        future: fetchHotelsByDepartment(department),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Hotel hotel = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.network(
                          hotel.thumbnail,
                          fit: BoxFit.cover, 
                          width: double.infinity, 
                          height: 250, 
                        ),
                        SizedBox(height: 8),
                        Text(
                          hotel.title,
                          style: TextStyle(
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
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                       hotel.tarifaEasy.isNotEmpty && hotel.moneda.isNotEmpty
                        ? Text(
                            'Precio: ${hotel.tarifaEasy} ${hotel.moneda} por noche',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                            ),
                          )
                        : Container(),
                        SizedBox(height: 10),
                         hotel.whatsapp.isNotEmpty
                        ? ElevatedButton(
                            onPressed: () => sendMessageToWhatsApp(context, hotel.whatsapp),
                            child: Text('Reservar'),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Theme.of(context).primaryColor, width: 2), // Borde del color primario
                              ),
                          )
                        : Text(
                            'Muy pronto',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
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
