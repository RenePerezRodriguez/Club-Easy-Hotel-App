
import 'package:club_easy_hotel/models/hotel.dart';

class ApiCacheManager {
  // Mapa para almacenar los datos de la caché.
  final Map<String, List<Hotel>> _cache = {};

  // Método para obtener datos de la caché.
  List<Hotel>? getFromCache(String key) {
    return _cache[key];
  }

  // Método para almacenar datos en la caché.
  void addToCache(String key, List<Hotel> data) {
    _cache[key] = data;
  }
}

// Instancia global de la clase ApiCacheManager.
final apiCacheManager = ApiCacheManager();
