// location_manager.dart
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationManager {
  Future<Position?> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica si los servicios de ubicación están habilitados.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Los servicios de ubicación no están habilitados, no se puede obtener la ubicación.
      return Future.error('Los servicios de ubicación están deshabilitados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Los permisos están denegados, no se puede obtener la ubicación.
        return Future.error('Los permisos de ubicación están denegados.');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Los permisos están denegados permanentemente, no se puede obtener la ubicación.
      return Future.error('Los permisos de ubicación están denegados permanentemente.');
    } 

    // Cuando los permisos están concedidos, obtiene la posición actual del usuario.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      // Solicitamos el permiso
      if (await Permission.location.request().isGranted) {
        // El permiso fue concedido
      } else {
        // El permiso fue denegado
        throw Exception('Permiso de ubicación denegado.');
      }
    }
  }
}
