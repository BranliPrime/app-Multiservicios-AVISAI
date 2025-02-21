// lib/screens/cancelled_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CancelledScreen extends StatefulWidget {
  const CancelledScreen({Key? key}) : super(key: key);

  @override
  State<CancelledScreen> createState() => _CancelledScreenState();
}

class _CancelledScreenState extends State<CancelledScreen> {
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
    final data = await ApiService.getInstalaciones(tecnicoId, "cancelada");
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
                  trailing: const Text('Cancelada'),
                ),
              );
            },
          );
  }
}
