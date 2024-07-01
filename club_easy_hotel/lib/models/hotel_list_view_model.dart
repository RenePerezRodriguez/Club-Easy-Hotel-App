import 'package:flutter/foundation.dart';
import 'package:club_easy_hotel/models/hotel.dart';
import 'package:club_easy_hotel/services/api_service.dart';

class HotelListViewModel extends ChangeNotifier {
  late Future<List<Hotel>> futureHotels;
  String? selectedDepartment;

  HotelListViewModel() {
    fetchHotels();
  }

  void fetchHotels() {
    futureHotels = ApiService.fetchHotels();
    notifyListeners(); // Notifica a los listeners que hay un cambio.
  }

  Future<void> onDepartmentChanged(String? newValue) async {
    if (newValue != null && newValue != selectedDepartment) {
      selectedDepartment = newValue;
      futureHotels = ApiService.fetchHotelsByDepartment(newValue);
      notifyListeners(); // Notifica a los listeners que hay un cambio.
    }
  }
}
