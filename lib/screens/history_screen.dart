// lib/screens/history_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> _instalaciones = [];
  bool _isLoading = true;
  int tecnicoId = 1; // ID de ejemplo

  @override
  void initState() {
    super.initState();
    _cargarInstalaciones();
  }

  Future<void> _cargarInstalaciones() async {
    setState(() {
      _isLoading = true;
    });
    // Asumimos que finalizadas = "finalizada"
    final data = await ApiService.getInstalaciones(tecnicoId, "finalizada");
    setState(() {
      _instalaciones = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _instalaciones.length,
            itemBuilder: (context, index) {
              final inst = _instalaciones[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(inst['titulo'] ?? 'Sin título'),
                  subtitle: Text('${inst['direccion']} - ${inst['fecha']}'),
                  trailing: const Text('Finalizada'),
                ),
              );
            },
          );
  }
}
