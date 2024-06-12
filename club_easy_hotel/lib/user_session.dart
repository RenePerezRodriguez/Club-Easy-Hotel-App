import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserSession with ChangeNotifier {
  String? _token;
  String? _userName;
  String? _userEmail;
  String? _userPhone;
  int? _userId;

  String? get token => _token;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userPhone => _userPhone;
  int? get userId => _userId;

  void setToken(String? token) {
    _token = token;
    notifyListeners();
  }

  void setUserName(String? userName) {
    _userName = userName;
    notifyListeners();
  }

  void setUserEmail(String? userEmail) {
    _userEmail = userEmail;
    notifyListeners();
  }

  void setUserPhone(String? userPhone) {
    _userPhone = userPhone;
    notifyListeners();
  }

  void setUserId(int? userId) {
    _userId = userId;
    notifyListeners();
  }

  // Método para validar el token recibido después del login
  Future<bool> validateToken(String token) async {
    final Uri parseTokenUri = Uri.parse('http://admin2.easyhotel.com.bo/sessions/parse_token?token=$token');
    final response = await http.get(parseTokenUri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        // Token es correcto, guardar los datos del usuario
        setToken(token);
        setUserName(jsonResponse['name']);
        setUserEmail(jsonResponse['email']);
        setUserPhone(jsonResponse['phone']);
        setUserId(jsonResponse['id']);
        return true; // Devuelve true si el token es válido
      } else {
        // Token es incorrecto, manejar el error
        return false; // Devuelve false si el token no es válido
      }
    } else {
      // Manejo de errores si la solicitud HTTP falla
      return false; // Devuelve false si hay un error en la solicitud HTTP
    }
  }

  // Método para cerrar sesión
  void logout() {
    setToken(null);
    setUserName(null);
    setUserEmail(null);
    setUserPhone(null);
    setUserId(null);
  }
}