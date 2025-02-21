// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nombreCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool isLoading = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre completo'),
            ),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
            ),
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                        errorMessage = '';
                      });

                      final nombre = nombreCtrl.text.trim();
                      final email = emailCtrl.text.trim();
                      final pass = passCtrl.text.trim();

                      if (nombre.isEmpty || email.isEmpty || pass.isEmpty) {
                        setState(() {
                          errorMessage = 'Todos los campos son requeridos.';
                          isLoading = false;
                        });
                        return;
                      }

                      final response = await ApiService.register(nombre, email, pass);
                      if (response['error'] != null) {
                        setState(() {
                          errorMessage = response['error'];
                          isLoading = false;
                        });
                      } else {
                        // Registro exitoso
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Registrarse'),
                  ),
          ],
        ),
      ),
    );
  }
}
