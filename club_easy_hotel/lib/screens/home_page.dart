import 'package:club_easy_hotel/data/departments_data.dart';
import 'package:club_easy_hotel/widgets/department_card.dart';
import 'package:club_easy_hotel/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:club_easy_hotel/models/user_session.dart';
import 'package:url_launcher/url_launcher.dart';

// Variable global para controlar la visibilidad del botón de compra de membresía.
bool showMembershipButton = false;

// HomePage es un StatelessWidget que representa la pantalla principal de la aplicación.
class HomePage extends StatelessWidget {
  // Constructor constante de HomePage con una clave opcional.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Utiliza el Provider para obtener el estado de la sesión del usuario.
    final isLoggedIn = Provider.of<UserSession>(context).token != null;
    // Accede a la sesión del usuario para obtener el nombre, si está disponible.
    final userSession = Provider.of<UserSession>(context);
    final String? name = userSession.userName;

    // Construye la interfaz de usuario de la página de inicio dentro de un Scaffold.
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Contenedor para la imagen de fondo y el saludo al usuario.
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  // Decoración con una imagen de fondo y un filtro de color.
                  image: DecorationImage(
                    image: const NetworkImage('https://easyhotel.com.bo/wp-content/uploads/2024/03/sasha-kaunas-TAgGZWz6Qg8-unsplash-scaled.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.darken,
                    ),
                  ),
                ),
                // Padding interno para el contenido del contenedor.
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Widget para mostrar el logo de EasyHotel.
                      Image.network(
                        'https://easyhotel.com.bo/wp-content/uploads/2024/06/logo-club.png',
                        width: 200,
                      ),
                      const SizedBox(height: 10),
                      // RichText para el mensaje de bienvenida personalizado.
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 0, // Hace el texto invisible.
                            color: Colors.white,
                          ),
                          children: [
                            const TextSpan(
                              text: '¡Bienvenido, ',
                            ),
                            TextSpan(
                              text: name ?? 'invitado',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor, // Utiliza el color primario del tema.
                              ),
                            ),
                            const TextSpan(
                              text: '!',
                            ),
                          ],
                        ),
                      ),
                // Espacio vertical para separar visualmente los elementos.
                const SizedBox(height: 20),

                // Texto destacado que promociona las ofertas de la aplicación.
                const Text(
                  'Las mejores tarifas en los mejores hoteles de Bolivia y del mundo.',
                  style: TextStyle(
                    color: Colors.white, // El color blanco asegura la legibilidad sobre el fondo oscuro.
                    fontSize: 25, // Tamaño de fuente adecuado para destacar la importancia del mensaje.
                    fontWeight: FontWeight.bold, // Negrita para dar énfasis al mensaje.
                  ),
                  textAlign: TextAlign.center, // Alineación central para una presentación equilibrada.
                ),

                // Otro espacio vertical para mantener una estética uniforme.
                const SizedBox(height: 20),

                // Botón condicional que se muestra solo si el usuario está autenticado y la variable showMembershipButton es verdadera.
                if (isLoggedIn && showMembershipButton) ...[
                  OutlinedButton(
                    onPressed: () {
                      // Función que se ejecuta al presionar el botón, en este caso, abrir un enlace web.
                      launchUrl(Uri.parse('http://admin2.easyhotel.com.bo//sessions/buy_card?redirect_to='));
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Theme.of(context).primaryColor), // Borde del botón con el color primario del tema.
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Bordes redondeados para un diseño moderno y amigable.
                      ),
                    ),
                    child: const Text('Comprar membresía'), // Texto del botón que invita a comprar la membresía.
                  ),
                ],

                // Espacio vertical antes de mostrar el widget de búsqueda.
                const SizedBox(height: 30),

                // Widget de búsqueda personalizado que permite a los usuarios buscar hoteles.
                SearchWidget(
                  onSearchResults: (results) {
                    // Navegación a la página de resultados de búsqueda cuando se obtienen resultados.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchResultsPage(searchResults: results),
                      ),
                    );
                  },
                ),

                // Espacio vertical adicional antes de mostrar el siguiente botón.
                const SizedBox(height: 50),

                // Botón que ofrece una búsqueda global de hoteles.
                OutlinedButton(
                  onPressed: () {
                    // Función que se ejecuta al presionar el botón, en este caso, abrir un enlace web.
                    launchUrl(Uri.parse('https://reservas.easyhotel.com.bo/easyhotel/search'));
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor, // Color del texto del botón que utiliza el color primario del tema.
                    side: BorderSide(color: Theme.of(context).primaryColor, width: 2), // Borde del botón con un ancho destacado.
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Bordes redondeados para mantener la consistencia del diseño.
                    ),
                  ),
                  child: const Text('Hoteles del mundo'), // Texto del botón que invita a explorar hoteles alrededor del mundo.
                ),
            ],
            ),
          ),
        ),
            // Espacio vertical para separar visualmente los elementos.
            const SizedBox(height: 15),
            // Columna que construye una lista de tarjetas de departamentos.
            Column(
              children: departmentsData.map((state) {
                // Crea una tarjeta de departamento para cada elemento en departmentsData.
                return DepartmentCard(department: state);
              }).toList(), // Convierte el resultado del map a una lista.
            ),
            // Espacio vertical después de la lista de tarjetas de departamentos.
            const SizedBox(height: 20),
          ],
          ),
        ),
      ),
    );
  }
}
