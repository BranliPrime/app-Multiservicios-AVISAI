// lib/screens/forgot_password_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailCtrl = TextEditingController();
  bool isLoading = false;
  String message = '';
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Contraseña')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
            ),
            const SizedBox(height: 20),
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: const TextStyle(color: Colors.red)),
            if (message.isNotEmpty)
              Text(message, style: const TextStyle(color: Colors.green)),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                        errorMessage = '';
                        message = '';
                      });

                      final email = emailCtrl.text.trim();
                      if (email.isEmpty) {
                        setState(() {
                          errorMessage = 'Ingresa un correo válido.';
                          isLoading = false;
                        });
                        return;
                      }

                      final response = await ApiService.forgotPassword(email);
                      if (response['error'] != null) {
                        setState(() {
                          errorMessage = response['error'];
                          isLoading = false;
                        });
                      } else {
                        setState(() {
                          message = response['message'];
                          isLoading = false;
                        });
                      }
                    },
                    child: const Text('Enviar enlace de recuperación'),
                  ),
          ],
        ),
      ),
    );
  }
}
