import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://localhost:3000/api"; 

  // 1. Registro
  static Future<Map<String, dynamic>> register(String nombre, String email, String password) async {
    try {
      final url = Uri.parse("$baseUrl/register");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"nombre": nombre, "email": email, "password": password}),
      );

      return _handleResponse(response);
    } catch (e) {
      return {"error": "Error de conexión: ${e.toString()}"};
    }
  }

  // 2. Login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final url = Uri.parse("$baseUrl/login");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email, "password": password}),
      );

      return _handleResponse(response);
    } catch (e) {
      return {"error": "Error de conexión: ${e.toString()}"};
    }
  }

  // 3. Recuperar contraseña
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final url = Uri.parse("$baseUrl/forgot-password");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email}),
      );

      return _handleResponse(response);
    } catch (e) {
      return {"error": "Error de conexión: ${e.toString()}"};
    }
  }

  // 4. Obtener instalaciones por estado
  static Future<List<dynamic>> getInstalaciones(int tecnicoId, String estado) async {
    try {
      final url = Uri.parse("$baseUrl/instalaciones/$tecnicoId/$estado");
      final response = await http.get(url);

      return _handleResponseList(response);
    } catch (e) {
      return [];
    }
  }

  // 5. Cancelar instalación
  static Future<Map<String, dynamic>> cancelarInstalacion(int id) async {
    try {
      final url = Uri.parse("$baseUrl/instalaciones/$id/cancelar");
      final response = await http.put(url);

      return _handleResponse(response);
    } catch (e) {
      return {"error": "Error de conexión: ${e.toString()}"};
    }
  }

  // 6. Finalizar instalación con foto
  static Future<Map<String, dynamic>> finalizarInstalacion(int id, File foto) async {
    try {
      final url = Uri.parse("$baseUrl/instalaciones/$id/finalizar");

      var request = http.MultipartRequest('PUT', url);
      if (foto.existsSync()) {
        request.files.add(await http.MultipartFile.fromPath('foto', foto.path));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      return {"error": "Error de conexión: ${e.toString()}"};
    }
  }

  // Manejo de respuestas para evitar errores inesperados
  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      return {"error": "Error ${response.statusCode}: ${response.body}"};
    }
  }

  static List<dynamic> _handleResponseList(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      return [];
    }
  }
}
