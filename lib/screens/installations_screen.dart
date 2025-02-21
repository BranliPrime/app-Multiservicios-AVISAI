// lib/screens/installations_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'installation_detail_screen.dart';

class InstallationsScreen extends StatefulWidget {
  const InstallationsScreen({Key? key}) : super(key: key);

  @override
  State<InstallationsScreen> createState() => _InstallationsScreenState();
}

class _InstallationsScreenState extends State<InstallationsScreen> {
  List<dynamic> _instalaciones = [];
  bool _isLoading = true;
  // Suponiendo que el id del técnico se obtiene de algún lugar (ej: provider, prefs)
  // Para demo, usaré un id fijo:
  int tecnicoId = 1;

  @override
  void initState() {
    super.initState();
    _cargarInstalaciones();
  }

  Future<void> _cargarInstalaciones() async {
    setState(() {
      _isLoading = true;
    });
    final data = await ApiService.getInstalaciones(tecnicoId, "pendiente");
    setState(() {
      _instalaciones = data;
      _isLoading = false;
    });
  }

  Future<void> _cancelarInstalacion(int id) async {
    final response = await ApiService.cancelarInstalacion(id);
    if (response['error'] == null) {
      // Actualizamos la lista
      await _cargarInstalaciones();
    }
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
                  subtitle: Text(
                      '${inst['direccion']} - ${inst['fecha']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InstallationDetailScreen(
                                instalacion: inst,
                                onRefresh: _cargarInstalaciones,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          _cancelarInstalacion(inst['id']);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
