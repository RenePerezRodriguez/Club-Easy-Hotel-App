import 'package:club_easy_hotel/models/hotel.dart';
import 'package:club_easy_hotel/models/user_session.dart';
import 'package:club_easy_hotel/services/api_service.dart';
import 'package:club_easy_hotel/widgets/hotel_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    List<Hotel> hotels = await ApiService.fetchHotels(); // Usa ApiService para llamar a la función.
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
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 40), 
    child: TextField(
      controller: _searchController,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(0, 60, 59, 59), 
        hintText: 'Buscar hoteles...',
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => _searchHotels(_searchController.text),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white), 
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white), 
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white), 
        ),
      ),
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
          return HotelCard(hotel: hotel);
              },
            )
    );
  }
}
