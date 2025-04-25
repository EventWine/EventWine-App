import "dart:convert";
import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import "package:http/http.dart" as http;
import 'package:eventwine/core/app_constants.dart';

final Uri signUpUrl = Uri.parse
    ('${AppConstants.baseURL}/api/auth/register');

final Uri signInUrl = Uri.parse
    ('${AppConstants.baseURL}/api/auth/login');

Future<String> registerUser(String name, String lastName, String email, String password) async {
  final requestData = {
    'name': name,
    'lastName': lastName,
    'email': email,
    'password': password,
  };

  final headers = {"Content-Type": "application/json"};
  
  print('Datos de registro: ${json.encode(requestData)}');
  print('Encabezados: $headers');
  print('URL de registro: $signUpUrl');

  try {
    final response = await http.post(
      signUpUrl,
      headers: headers,
      body: json.encode(requestData),
    );

    if (response.statusCode == 201) {
      return "Usuario registrado exitosamente.";
    } else {
      if (response.body.isNotEmpty) {
        final errorResponse = json.decode(response.body);
        final errorMessage = errorResponse['message'] ?? 'Error desconocido';
        print('Error al registrar usuario: $errorMessage');
        return "Error al registrar usuario: $errorMessage";
      } else {
        print(
            'Error al registrar usuario: Código de estado ${response.statusCode}');
        return "Error al registrar usuario: Código de estado ${response.statusCode}";
      }
    }
  } catch (e) {
    print('Error de conexión: $e');
    return "Error de conexión: $e";
  }
}

Future<String> loginUser(String email, String password, BuildContext context) async {
  try {
    final response = await http.post(
      signInUrl,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final token = data['token'];
      final userId = data['id'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);

      await prefs.setInt('userId', userId);
      await prefs.setString('user_id', userId.toString());


      Navigator.pushReplacementNamed(context, '/home');

      print('Token: $token');
      print('UserId: $userId');
      return "Inicio de sesión exitoso.";
    } else {
      print('Error al iniciar sesión: ${response.body}');
      return "Error al iniciar sesión: ${response.body}";
    }
  } catch (e) {
    print('Error de conexión: $e');
    return "Error de conexión: $e";
  }
}