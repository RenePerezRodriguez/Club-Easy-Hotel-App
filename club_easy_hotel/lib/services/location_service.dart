import 'package:geolocator/geolocator.dart';

Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica si los servicios de ubicación están habilitados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Los servicios de ubicación no están habilitados, no continúes
      // y solicita que se activen los servicios de ubicación.
      return Future.error('Los servicios de ubicación están deshabilitados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Los permisos están denegados, no continúes
        return Future.error('Los permisos de ubicación están denegados');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Los permisos están denegados permanentemente, no continúes
      return Future.error(
        'Los permisos de ubicación están permanentemente denegados, no podemos solicitar permisos.');
    } 

    // Cuando tenemos permisos, obtenemos la posición actual
    return await Geolocator.getCurrentPosition();
  }