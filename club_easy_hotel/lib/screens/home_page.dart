import 'package:club_easy_hotel/screens/webview_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:club_easy_hotel/models/user_session.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:club_easy_hotel/data/departments_data.dart';
import 'package:club_easy_hotel/widgets/department_card.dart';
import 'package:club_easy_hotel/widgets/search_widget.dart';

// Variable global para controlar la visibilidad del botón de compra de membresía.
bool showMembershipButton = false;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Provider.of<UserSession>(context).token != null;
    final userSession = Provider.of<UserSession>(context);
    final String? name = userSession.userName;

    int crossAxisCount = MediaQuery.of(context).size.width > 560 ? 2 : 1;
    double totalHeight = (departmentsData.length / crossAxisCount).ceil() * 320;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const NetworkImage('https://easyhotel.com.bo/wp-content/uploads/2024/03/sasha-kaunas-TAgGZWz6Qg8-unsplash-scaled.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'https://easyhotel.com.bo/wp-content/uploads/2024/06/logo-club.png',
                        width: 200,
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 0,
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
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const TextSpan(
                              text: '!',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Las mejores tarifas en los mejores hoteles de Bolivia y del mundo.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      if (isLoggedIn && showMembershipButton) ...[
                        OutlinedButton(
                          onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewPage(url: 'http://admin2.easyhotel.com.bo//sessions/buy_card?redirect_to='),
                            ),
                          );
                        },
                          child: const Text('Comprar membresía'),
                        ),
                      ],
                      const SizedBox(height: 30),
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
                      const SizedBox(height: 50),
                      OutlinedButton(
                        onPressed: () async {
                          final Uri url = Uri.parse('https://reservas.easyhotel.com.bo/easyhotel/search');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(
                              url,
                              mode: LaunchMode.externalApplication, // Ensures the URL opens in an external browser
                            );
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor,
                          side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Hoteles del mundo'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
            

              Container(
                height: totalHeight, // Usa la altura total calculada.
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisExtent: 300,
                    childAspectRatio: 3,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 10.0,
                  ),
                  itemCount: departmentsData.length,
                  itemBuilder: (context, index) {
                    return DepartmentCard(department: departmentsData[index]);
                  },
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
