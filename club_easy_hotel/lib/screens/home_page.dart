import 'package:club_easy_hotel/screens/department_hotels_page.dart';
import 'package:club_easy_hotel/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:club_easy_hotel/models/user_session.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Map<String, String>> departments = [
  {
    'name': 'La-Paz',
    'image': 'https://easyhotel.com.bo/wp-content/uploads/2024/03/marraketa-i4A-nrtqyPw-unsplash-scaled.jpg',
  },
  {
    'name': 'Santa-Cruz',
    'image': 'https://media.istockphoto.com/id/887636194/es/foto/christian-cathedral-de-santa-cruz-de-las-sierras-bolivia.webp?b=1&s=170667a&w=0&k=20&c=rJlqgFNNnIm-5naKu4OUbOaLNhcM6xIDSBK63meYEFM=',
  },
  {
    'name': 'Cochabamba',
    'image': 'https://easyhotel.com.bo/wp-content/uploads/2024/03/pexels-david-renken-15013675-scaled.jpg',
  },
  {
    'name': 'Tarija',
    'image': 'https://media.istockphoto.com/id/1063784930/es/foto/departamento-de-estado-de-tarija-de-bolivia-bandera-tela-tela-ondeando-en-la-niebla-de-la.webp?b=1&s=170667a&w=0&k=20&c=g_q8VXnmP5K4zjOIGSNq3qSxCjTjyQvI4ySVEOTu7xA=',
  },
  {
    'name': 'Potosi',
    'image': 'https://images.pexels.com/photos/13575545/pexels-photo-13575545.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  },
  {
    'name': 'Chuquisaca',
    'image': 'https://www.travelandes.com/img/GalleryContent/112619/sucre2.jpg',
  },
  {
    'name': 'Oruro',
    'image': 'https://images.pexels.com/photos/16963298/pexels-photo-16963298/free-photo-of-gente-calle-festival-musica.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  },
  {
    'name': 'Pando',
    'image': 'https://media.istockphoto.com/id/1063784892/es/foto/estado-de-pando-departamento-de-bolivia-bandera-tela-tela-ondeando-en-la-niebla-de-la-niebla.webp?b=1&s=170667a&w=0&k=20&c=IesPdd2BRHpV2nn6EiGgiLSBYMRbajUWV7oRkCiWSZ4=',
  },
  {
    'name': 'Beni',
    'image': 'https://boliviaesturismo.com/wp-content/uploads/2016/05/beni.jpg',
  },
];


  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Provider.of<UserSession>(context).token != null;
    final userSession = Provider.of<UserSession>(context);
    final String? name = userSession.userName;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView( // Envuelve todo en un SingleChildScrollView
          child: Column(
            children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://easyhotel.com.bo/wp-content/uploads/2024/03/sasha-kaunas-TAgGZWz6Qg8-unsplash-scaled.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), // Ajusta la opacidad aquí
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Añade un padding para el contenido
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://easyhotel.com.bo/wp-content/uploads/2024/06/logo-club.png',
                      width: 200,
                    ),
                const SizedBox(height: 10),
                const Text(
                  '¡Bienvenido, invitado!',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Las mejores tarifas en los mejores hoteles del pais.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                if (isLoggedIn) ...[
                  OutlinedButton(
                    onPressed: () {
                      // Reemplaza con el enlace al que quieres que lleve el botón
                      launchUrl(Uri.parse('http://admin2.easyhotel.com.bo//sessions/buy_card?redirect_to='));
                    },
                    child: const Text('Comprar membresía'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), 
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                SearchWidget(
                  onSearchResults: (results) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchResultsPage(searchResults: results),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
            ],
            ),
          ),
        ),
            /*const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'Departamentos',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),*/
           /* const SizedBox(height: 20),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Selecciona un departamento para ver los hoteles disponibles',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),*/
            const SizedBox(height: 15),

            // Lista de departamentos
              GridView.builder(
                shrinkWrap: true, // Importante para que funcione dentro de SingleChildScrollView
                physics: NeverScrollableScrollPhysics(), // Para evitar el desplazamiento propio de la GridView
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: departments.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Acción cuando se toca el departamento
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DepartmentHotelsPage(department: departments[index]['name']!),
                        ),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(departments[index]['image']!),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.8),
                                Colors.transparent, 
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                departments[index]['name']!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DepartmentHotelsPage(department: departments[index]['name']!),
                                    ),
                                  );
                                },
                                child: Text('Ver hoteles'),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Theme.of(context).primaryColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10), 
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(height: 20),
          ],
          ),
        ),
      ),
    );
  }
}
