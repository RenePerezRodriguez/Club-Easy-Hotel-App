import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:club_easy_hotel/models/user_session.dart';

class WebViewPageLogin extends StatefulWidget {
  final String url; // Nuevo parámetro para la URL
  const WebViewPageLogin({super.key, required this.url});

  @override
  WebViewPageLoginState createState() => WebViewPageLoginState();
}

class WebViewPageLoginState extends State<WebViewPageLogin> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Actualizar barra de carga.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('myapp://')) {
              // Intercepta la URL personalizada
              final Uri uri = Uri.parse(request.url);
              final String? sessionToken = uri.queryParameters['session_token'];
              if (sessionToken != null) {
                // Maneja el token de sesión
                Provider.of<UserSession>(context, listen: false).validateToken(sessionToken).then((isValid) {
                  if (isValid) {
                    // Navega a la pantalla de usuario logueado
                    Navigator.pop(context); // Cierra el WebView y regresa a la pantalla anterior
                  } else {
                    // Muestra un mensaje de error
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('El token de sesión no es válido.'),
                      ),
                    );
                  }
                });
              }
              return NavigationDecision.prevent; // Previene que WebView intente cargar la URL personalizada
            }
            return NavigationDecision.navigate; // Permite la navegación a URLs normales
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url)); // Carga la URL pasada como parámetro
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acceder'),
      ),
      body: WebViewWidget(controller: _controller), // Asegúrate de que WebViewWidget maneje la nueva URL
    );
  }
}
