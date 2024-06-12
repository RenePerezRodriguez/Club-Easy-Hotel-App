// routes.dart
import 'package:club_easy_hotel/main.dart';
import 'package:flutter/material.dart';
import 'screens/hotel_list_page.dart';
import 'screens/web_view_page.dart';
import 'screens/login_page.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/home': (context) => const MyHomePage(),
  '/hotelList': (context) => const HotelListPage(),
  '/webView': (context) => const WebViewPage(),
  '/login': (context) => const LoginPage(),
  // Añade más rutas según sea necesario
};
