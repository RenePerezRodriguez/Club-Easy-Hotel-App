import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class UserSession with ChangeNotifier {
  String? _token;
  String? _userImage;
  String? _userName;
  String? _clientDni;
  String? _userEmail;
  String? _userPhone;
  int? _userId;

  String? get token => _token;
  String? get userImage => _userImage;
  String? get userName => _userName;
  String? get clientDni => _clientDni;
  String? get userEmail => _userEmail;
  String? get userPhone => _userPhone;
  int? get userId => _userId;


Future<void> redirectToLogin(BuildContext context) async {
    const String redirectUrl = 'myapp://login_success';
    final String encodedRedirectUrl = Uri.encodeFull(redirectUrl);
    final String loginUrl = 'http://admin2.easyhotel.com.bo/sessions/new?redirect_to=$encodedRedirectUrl';

    if (await canLaunch(loginUrl)) {
      await launch(loginUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo realizar la redirección para el login.'),
        ),
      );
    }
  }
  
  void setToken(String? token) {
    _token = token;
    notifyListeners();
  }

  void setclientDni(String? clientDni) {
    _clientDni = clientDni;
    notifyListeners();
  }

  void setUserImage(String? userImage) {
    _userImage = userImage;
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
        setUserImage(jsonResponse['image']);
        setUserName(jsonResponse['name']);
        setclientDni(jsonResponse['dni']);
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
    setclientDni(null);
    setUserEmail(null);
    setUserPhone(null);
    setUserId(null);
  }
}
