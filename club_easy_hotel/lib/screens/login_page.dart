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
  Timer? _timer;
  static bool _hasRedirected = false; // Variable estática para rastrear la redirección

  @override
  void initState() {
    super.initState();
    _handleDeepLink();
  }

  @override
  void dispose() {
    _sub?.cancel();
    _timer?.cancel();
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
    if (!_hasRedirected) { // Verifica si ya se ha redirigido al usuario
      _timer = Timer(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacementNamed('/home');
        _hasRedirected = true; // Marca que se ha realizado la redirección
      });
    }
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
    _timer?.cancel(); // Asegúrate de cancelar el timer al cerrar sesión
    setState(() {
      _timer = null; // Restablece el timer a null
    });
  }

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);
    final bool isLoggedIn = userSession.token != null;

    if (isLoggedIn && !_hasRedirected) {
      _handleLoginSuccess();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Membresía'),
      ),
      body: isLoggedIn
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
