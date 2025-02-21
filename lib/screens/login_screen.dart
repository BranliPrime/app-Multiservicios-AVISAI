import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool isLoading = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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

                      final email = emailCtrl.text.trim();
                      final pass = passCtrl.text.trim();

                      if (email.isEmpty || pass.isEmpty) {
                        setState(() {
                          errorMessage = 'Correo y contraseña requeridos.';
                          isLoading = false;
                        });
                        return;
                      }

                      final response = await ApiService.login(email, pass);

                      if (response.containsKey('error')) {
                        setState(() {
                          errorMessage = response['error'];
                          isLoading = false;
                        });
                      } else if (response.containsKey('user')) {
                        final user = response['user']; // Guardamos el usuario
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.pushReplacementNamed(
                          context, 
                          '/home',
                          arguments: user,  // Pasamos los datos del usuario
                        );
                      } else {
                        setState(() {
                          errorMessage = 'Error inesperado en el servidor.';
                          isLoading = false;
                        });
                      }
                    },
                    child: const Text('Ingresar'),
                  ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/forgotPassword');
              },
              child: const Text('¿Olvidaste tu contraseña?'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}
