import 'package:club_easy_hotel/models/hotel.dart';
import 'package:club_easy_hotel/widgets/hotel_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:club_easy_hotel/models/user_session.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:club_easy_hotel/services/api_service.dart'; // Importa ApiService.

class DepartmentHotelsPage extends StatelessWidget {
  final String department;

  const DepartmentHotelsPage({super.key, required this.department});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Provider.of<UserSession>(context).token != null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hoteles en $department'),
      ),
      body: FutureBuilder<List<Hotel>>(
        future: ApiService.fetchHotelsByDepartment(department), // Usa ApiService para llamar a la función.
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return AlignedGridView.count(
              crossAxisCount: MediaQuery.of(context).size.width > 560 ? 2 : 1, // Número de columnas para tablets
              mainAxisSpacing: 2,
              crossAxisSpacing: 2,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return HotelCard(hotel: snapshot.data![index]);
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
