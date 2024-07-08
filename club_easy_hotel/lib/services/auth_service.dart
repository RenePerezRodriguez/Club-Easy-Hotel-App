import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Método para validar el token recibido después del login
  Future<bool> validateToken(String token) async {
    final Uri parseTokenUri = Uri.parse('http://admin2.easyhotel.com.bo/sessions/parse_token?token=$token');
    final response = await http.get(parseTokenUri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        // Guarda los datos del usuario en las preferencias compartidas
        await prefs.setInt('userId', jsonResponse['id']);
        await prefs.setString('userImage', jsonResponse['image']);
        await prefs.setString('userName', jsonResponse['name']);
        await prefs.setString('clientDni', jsonResponse['dni']);
        await prefs.setString('userEmail', jsonResponse['expires_at']);
        await prefs.setString('userPhone', jsonResponse['phone']);
        await prefs.setString('userToken', token);
        return true; // Devuelve true si el token es válido
      } else {
        // Token es incorrecto, manejar el error
        // Aquí puedes agregar lógica para manejar tokens incorrectos, como mostrar un mensaje al usuario
        return false; // Devuelve false si el token no es válido
      }
    } else {
      // Manejo de errores si la solicitud HTTP falla
      // Aquí puedes agregar lógica para manejar errores de red, como reintentar la solicitud o mostrar un mensaje de error
      return false; // Devuelve false si hay un error en la solicitud HTTP
    }
  }

  // Método para cerrar sesión y limpiar las preferencias compartidas
  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userImage');
    await prefs.remove('userName');
    await prefs.remove('clientDni');
    await prefs.remove('userEmail');
    await prefs.remove('userPhone');
    await prefs.remove('userToken');
    // Asegúrate de eliminar todos los datos relacionados con la sesión del usuario
  }
}
