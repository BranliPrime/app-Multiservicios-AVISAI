import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class InstallationDetailScreen extends StatefulWidget {
  final Map<String, dynamic> instalacion;
  final Function onRefresh;

  const InstallationDetailScreen({
    Key? key,
    required this.instalacion,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<InstallationDetailScreen> createState() => _InstallationDetailScreenState();
}

class _InstallationDetailScreenState extends State<InstallationDetailScreen> {
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _finalizarInstalacion() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, toma una foto antes de finalizar.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await ApiService.finalizarInstalacion(
      widget.instalacion['id'],
      _selectedImage!,
    );

    if (response['error'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Instalación finalizada con éxito')),
      );
      // Actualizamos la lista de instalaciones en la pantalla anterior
      await widget.onRefresh();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response['error']}')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final inst = widget.instalacion;

    return Scaffold(
      appBar: AppBar(
        title: Text(inst['titulo'] ?? 'Detalle'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dirección: ${inst['direccion'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Fecha: ${inst['fecha'] ?? ''}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Descripción: ${inst['descripcion'] ?? ''}'),
            const SizedBox(height: 20),
            _selectedImage == null
                ? Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.camera_alt, size: 50),
                  )
                : Image.file(_selectedImage!, width: 200, height: 200),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Tomar Foto'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _finalizarInstalacion,
                    child: const Text('Finalizar Instalación'),
                  ),
          ],
        ),
      ),
    );
  }
}
