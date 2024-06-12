import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Hotel>> fetchHotels() async {
  try {
    final response = await http.get(
      Uri.parse('https://easyhotel.com.bo/wp-json/easyhotel/v1/hoteles/'),
    ).timeout(const Duration(seconds: 10)); // Timeout de 10 segundos

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Hotel.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar los hoteles desde la API');
    }
  } catch (e) {
    throw Exception('Error al realizar la solicitud: $e');
  }
}

Future<List<Hotel>> fetchHotelsByDepartment(String department) async {
  try {
    final response = await http.get(
      Uri.parse('https://easyhotel.com.bo/wp-json/easyhotel/v1/hoteles/$department'),
    ).timeout(const Duration(seconds: 10)); // Timeout de 10 segundos

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Hotel.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar los hoteles del departamento desde la API');
    }
  } catch (e) {
    throw Exception('Error al realizar la solicitud: $e');
  }
}


class Hotel {
  final int id;
  final String title;
  final int estrellas;
  final String direccion;
  final String precioRack;
  final String tarifaEasy;
  final String thumbnail;
  final String facebook;
  final String instagram;
  final String whatsapp;
  final String enlaceGenerico;
  final String moneda;
  final List<String> departamentos;

  Hotel({
    required this.id,
    required this.title,
    required this.estrellas,
    required this.direccion,
    required this.precioRack,
    required this.tarifaEasy,
    required this.thumbnail,
    required this.facebook,
    required this.instagram,
    required this.whatsapp,
    required this.enlaceGenerico,
    required this.moneda,
    required this.departamentos,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'],
      title: json['title'],
      estrellas: int.parse(json['estrellas']),
      direccion: json['direccion'],
      precioRack: json['precio_rack'],
      tarifaEasy: json['tarifa_easy'],
      thumbnail: json['thumbnail'],
      facebook: json['facebook'],
      instagram: json['instagram'],
      whatsapp: json['whatsapp'],
      enlaceGenerico: json['enlace_generico'],
      moneda: json['moneda'],
      departamentos: List<String>.from(json['departamentos']),
    );
  }
}

