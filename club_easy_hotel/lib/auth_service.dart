import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class AuthService {
  Future<void> validateToken(String token) async {
    final Uri parseTokenUri = Uri.parse('http://admin2.easyhotel.com.bo/sessions/parse_token?token=$token');
    final response = await http.get(parseTokenUri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', jsonResponse['id']);
      await prefs.setString('userName', jsonResponse['name']);
      // Guarda otros datos necesarios
    } else {
        // Token es incorrecto, manejar el error
        // ...
      }
    } else {
      // Manejo de errores si la solicitud HTTP falla
      // ...
    }
  }
}