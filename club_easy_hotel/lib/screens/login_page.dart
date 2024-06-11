import 'package:club_easy_hotel/user_session.dart';
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
  StreamSubscription? _sub; // Variable para la suscripción al stream

  @override
  void initState() {
    super.initState();
    _handleDeepLink();
  }

  @override
  void dispose() {
    // Cancela la suscripción al stream cuando el widget se deshaga
    _sub?.cancel();
    super.dispose();
  }

  void _handleDeepLink() {
    // Escucha los deep links entrantes usando uriLinkStream
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        final String? sessionToken = uri.queryParameters['session_token'];
        if (sessionToken != null) {
          Provider.of<UserSession>(context, listen: false)
              .validateToken(sessionToken)
              .then((bool isValid) {
            if (isValid) {
              Navigator.of(context).pushReplacementNamed('/home');
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: redirectToLogin,
          child: const Text('Iniciar Sesión'),
        ),
      ),
    );
  }
}
