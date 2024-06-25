import 'package:club_easy_hotel/screens/department_hotels_page.dart';
import 'package:club_easy_hotel/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:club_easy_hotel/models/user_session.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<String> departments = [
    
    'La-Paz',
    'Santa-Cruz',
    'Tarija',
    'Potosi',
    'Cochabamba',
    'Chuquisaca',
    'Oruro',
    'Pando',
    'Beni',
  ];

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);
    final String? name = userSession.userName;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        color: Colors.black, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 60),
            Row(
              children: [
                Image.network(
                  'https://easyhotel.com.bo/wp-content/uploads/2024/03/logo-2-fondo-1.png',
                  width: 50,
                ),
                const SizedBox(width: 10), 
                const Text(
                  'Club Easy Hotel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: '¡Bienvenido, ',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: name ?? "invitado", 
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).primaryColor, 
                    ),
                  ),
                  const TextSpan(
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

            const Align(
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
            ),
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
            ),
            const SizedBox(height: 20),

            // Lista de departamentos
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
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
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

