import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void sendMessageToWhatsApp(BuildContext context, String phoneNumber, String message) async {
  final Uri whatsappUri = Uri.parse("whatsapp://send?phone=+$phoneNumber&text=${Uri.encodeFull(message)}");
  final Uri whatsappWebUri = Uri.parse("https://wa.me/$phoneNumber/?text=${Uri.encodeFull(message)}");

  if (await canLaunchUrl(whatsappUri)) {
    await launchUrl(whatsappUri);
  } else if (await canLaunchUrl(whatsappWebUri)) {
    await launchUrl(whatsappWebUri);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No se pudo abrir WhatsApp ni WhatsApp Web.'),
      ),
    );
  }
}
