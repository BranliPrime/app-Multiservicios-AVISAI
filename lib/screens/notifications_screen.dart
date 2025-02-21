import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("NOTIFICACIONES", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          _buildNotificationSection("Nuevo servicio asignado", "Cliente: Rojas\nDirección: AV. Siempre Viva 123\nHace 6 minutos"),
          const SizedBox(height: 10),
          _buildNotificationSection("Servicio cancelado", "Tu pedido N° 12345 ha sido cancelado\nHace 10 minutos"),
        ],
      ),
    );
  }

  Widget _buildNotificationSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(content, style: const TextStyle(fontSize: 14, color: Colors.black87)),
        ),
      ],
    );
  }
}
