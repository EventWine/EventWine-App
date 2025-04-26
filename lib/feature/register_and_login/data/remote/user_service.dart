import 'package:eventwine/feature/register_and_login/data/remote/user_model.dart';
class UserService {
  // Simulando una lista de usuarios registrados
  static List<UserModel> _users = [];

  // Función de registro
  static Future<String> registerUser(String username, String password, {String role = ''}) async {
    // Simulamos un pequeño retraso de red
    await Future.delayed(const Duration(seconds: 2));

    // Verificar si el nombre de usuario ya está registrado
    for (var user in _users) {
      if (user.username == username) {
        return 'El usuario ya está registrado';
      }
    }

    // Registrar al nuevo usuario
    _users.add(UserModel(username: username, password: password, role: role));

    return 'Registro exitoso';
  }

  // Función de login
  static Future<String> loginUser(String username, String password) async {
    // Simulamos un pequeño retraso de red
    await Future.delayed(const Duration(seconds: 2));

    // Buscar al usuario
    for (var user in _users) {
      if (user.username == username && user.password == password) {
        return 'Login exitoso';
      }
    }

    return 'Usuario o contraseña incorrectos';
  }
}
