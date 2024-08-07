import 'package:club_easy_hotel/models/user_session.dart';
import 'package:club_easy_hotel/screens/webview_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  late final AppLinks _appLinks;
  StreamSubscription? _sub;


  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _handleDeepLink();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _handleDeepLink() {
    _sub = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        final String? sessionToken = uri.queryParameters['session_token'];
        if (sessionToken != null) {
          Provider.of<UserSession>(context, listen: false)
              .validateToken(sessionToken)
              .then((bool isValid) {
            if (isValid) {
              setState(() {
                _handleLoginSuccess();
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
  }

   @override
    Widget build(BuildContext context) {
      final userSession = Provider.of<UserSession>(context);
      final bool isLoggedIn = userSession.token != null;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Mi Membresía'),
          backgroundColor: Colors.black,
        ),
        body: isLoggedIn
            ? ListView(
                padding: const EdgeInsets.all(16.0),
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.transparent,
                      backgroundImage: userSession.userImage != null && userSession.userImage!.startsWith('http')
                        ? NetworkImage(userSession.userImage!) // Si es una URL válida, carga la imagen de la red
                        : null,
                      child: userSession.userImage == null || !userSession.userImage!.startsWith('http')
                        ? Icon(
                            Icons.person,
                            size: 100,
                            color: Theme.of(context).primaryColor,
                          )
                        : null,
                    ),
                  ),


                 const SizedBox(height: 16),
                  ListTile(
                    leading: Icon(Icons.person, color: Theme.of(context).primaryColor),
                    title: Text(
                      'Nombre: ',
                      style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      userSession.userName ?? "No disponible",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.credit_card, color: Theme.of(context).primaryColor),
                    title: Text(
                      'Documento de identidad: ',
                      style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      userSession.clientDni ?? "No disponible",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.card_membership_outlined, color: Theme.of(context).primaryColor),
                    title: Text(
                      'Fecha de vencimiento',
                      style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      userSession.userEmail ?? "No disponible",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone, color: Theme.of(context).primaryColor),
                    title: Text(
                      'Teléfono: ',
                      style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      userSession.userPhone ?? "No disponible",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<UserSession>(context, listen: false).logout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text(
                      'Cerrar Sesión',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.network(
                      'https://easyhotel.com.bo/wp-content/uploads/2024/03/logo-2-fondo-1.png',
                      width: 100, // Aumenta el ancho de la imagen
                    ),
                  ),
                  const SizedBox(height: 20),
                  Platform.isIOS ? Container() : ElevatedButton(
                    onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebViewPage(url: 'https://admin2.easyhotel.com.bo/sessions/buy_card'),
                          ),
                        );
                      },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Comprar Membresía',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // Texto en negrita
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<UserSession>(context, listen: false).redirectToLogin(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Acceder a mi cuenta',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // Texto en negrita
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )

      );
    }
  }
