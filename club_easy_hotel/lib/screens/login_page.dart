import 'package:club_easy_hotel/models/user_session.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async'; // Importa dart:async para usar StreamSubscription

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  StreamSubscription? _sub;
  bool _isLoggedIn = false; // Añade una variable para rastrear el estado de inicio de sesión
  Timer? _timer; // Añade un Timer para la redirección

  @override
  void initState() {
    super.initState();
    _handleDeepLink();
  }

  @override
  void dispose() {
    _sub?.cancel();
    _timer?.cancel(); // Cancela el timer si está activo
    super.dispose();
  }

  void _handleDeepLink() {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        final String? sessionToken = uri.queryParameters['session_token'];
        if (sessionToken != null) {
          Provider.of<UserSession>(context, listen: false)
              .validateToken(sessionToken)
              .then((bool isValid) {
            if (isValid) {
              setState(() {
                _isLoggedIn = true; // Actualiza el estado a logueado
                _handleLoginSuccess(); // Llama al método para manejar el éxito del inicio de sesión
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('El token de sesión no es válido.'),
                ),
              );
            }
          });
        }
      }
    }, onError: (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al manejar el deep link: $err'),
        ),
      );
    });
  }

  void _handleLoginSuccess() {
    // Redirige al usuario a la página de inicio después de 2 segundos
    _timer = Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed('/home'); // Asegúrate de que la ruta '/home' esté definida en tu MaterialApp
    });
  }

  // Método para redirigir al usuario a la página de login del servidor
  void redirectToLogin() async {
    const String redirectUrl = 'myapp://login_success';
    final String encodedRedirectUrl = Uri.encodeFull(redirectUrl);
    final String loginUrl = 'http://admin2.easyhotel.com.bo/sessions/new?redirect_to=$encodedRedirectUrl';

    if (await canLaunch(loginUrl)) {
      await launch(loginUrl);
    } else {
      // Manejo de errores si no se puede abrir la URL
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo realizar la redirección para el login.'),
        ),
      );
    }
  }

  void _logout() {
    Provider.of<UserSession>(context, listen: false).logout();
    setState(() {
      _isLoggedIn = false; // Actualiza el estado a no logueado
    });
  }

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Membresía'),
      ),
      body: _isLoggedIn
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Token: ${userSession.token ?? "No disponible"}'),
                  Text('Nombre: ${userSession.userName ?? "No disponible"}'),
                  Text('Correo Electrónico: ${userSession.userEmail ?? "No disponible"}'),
                  Text('Teléfono: ${userSession.userPhone ?? "No disponible"}'),
                  ElevatedButton(
                    onPressed: _logout,
                    child: const Text('Cerrar Sesión'),
                  ),
                ],
              ),
            )
          : Center(
              child: ElevatedButton(
                onPressed: redirectToLogin,
                child: const Text('Iniciar Sesión'),
              ),
            ),
    );
  }
}
