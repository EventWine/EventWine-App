import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:eventwine/feature/register_and_login/data/remote/user_model.dart';
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

  static Future<String> loginUser(String username, String password) async {
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
      return 'Login exitoso';
    } else {
      return 'Usuario o contraseña incorrectos';
    }
  }
}
