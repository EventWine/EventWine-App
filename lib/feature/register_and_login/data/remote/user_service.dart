import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:eventwine/core/app_constants.dart';

class UserService {
  static Future<String> registerUser(String username, String password, {String role = ''}) async {
    final url = Uri.parse('${AppConstants.baseURL}/authentication/sign-up');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": username,
        "password": password
      }),
    );

    if (response.statusCode == 200) {
      return 'Registro exitoso';
    } else {
      return 'Error al registrar usuario: ${response.body}';
    }
  }

  static Future<Map<String, dynamic>> loginUser(String username, String password) async {
    final url = Uri.parse('${AppConstants.baseURL}/authentication/sign-in');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token']; // Usas el token si quieres
      final userId = data['id']; // Obtenemos el userId
      return {'message': 'Login exitoso', 'userId': userId};
    } else {
      return {'message': 'Usuario o contraseña incorrectos'};
    }
  }

  static Future<Map<String, dynamic>?> getProfileByUserId(int userId) async {
    final url = Uri.parse('${AppConstants.baseURL}/profiles/user/$userId');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error al obtener el perfil por UserId: ${response.statusCode} - ${response.body}');
      return null;
    }
  }
}