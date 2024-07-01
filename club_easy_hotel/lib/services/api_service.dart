import 'dart:convert';
import 'package:club_easy_hotel/api_cache_manager.dart';
import 'package:club_easy_hotel/models/hotel.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<Hotel>> fetchHotels() async {
    String cacheKey = 'allHotels';
    List<Hotel>? cachedHotels = apiCacheManager.getFromCache(cacheKey);
    if (cachedHotels != null) {
      return cachedHotels;
    }

    try {
      final response = await http.get(
        Uri.parse('https://easyhotel.com.bo/wp-json/easyhotel/v1/hoteles/'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        List<Hotel> hotels = jsonResponse.map((item) => Hotel.fromJson(item)).toList();
        apiCacheManager.addToCache(cacheKey, hotels);
        return hotels;
      } else {
        throw Exception('Error al cargar los hoteles desde la API');
      }
    } catch (e) {
      throw Exception('Error al realizar la solicitud: $e');
    }
  }

  static Future<List<Hotel>> fetchHotelsByDepartment(String department) async {
    String cacheKey = 'hotelsByDepartment_$department';
    List<Hotel>? cachedHotels = apiCacheManager.getFromCache(cacheKey);
    if (cachedHotels != null) {
      return cachedHotels;
    }

    try {
      final response = await http.get(
        Uri.parse('https://easyhotel.com.bo/wp-json/easyhotel/v1/hoteles/$department'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        List<Hotel> hotels = jsonResponse.map((item) => Hotel.fromJson(item)).toList();
        apiCacheManager.addToCache(cacheKey, hotels);
        return hotels;
      } else {
        throw Exception('Error al cargar los hoteles del departamento desde la API');
      }
    } catch (e) {
      throw Exception('Error al realizar la solicitud: $e');
    }
  }
}
