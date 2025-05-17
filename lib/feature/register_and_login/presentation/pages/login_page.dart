import 'package:flutter/material.dart';
import 'package:eventwine/feature/register_and_login/data/remote/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eventwine/feature/home/presentation/pages/home_page.dart'; // Importa HomePage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final responseLogin = await UserService.loginUser(
        _usernameController.text.trim(),
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (responseLogin['message'].toLowerCase().contains("exitoso")) {
        final userId = responseLogin['userId'];
        if (userId != null) {
          final profileData = await UserService.getProfileByUserId(userId);
          if (profileData != null && profileData.containsKey('fullName')) {
            final fullName = profileData['fullName'];
            final prefs = await SharedPreferences.getInstance();
            await prefs.setInt('userId', userId); // Guardar el userId
            print('LoginPage - userId guardado: $userId'); // Línea de depuración
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()), // Navega a HomePage sin pasar fullName
            );
          } else {
            // Manejar el caso en que no se obtiene el perfil
            setState(() {
              _errorMessage = 'Error al cargar la información del perfil.';
            });
          }
        } else {
          setState(() {
            _errorMessage = 'Error al obtener el ID del usuario.';
          });
        }
      } else {
        setState(() {
          _errorMessage = responseLogin['message'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F6E9),
              border: Border.all(color: Colors.brown, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset('assets/logo_eventwine.jpg', height: 100),
                  const SizedBox(height: 20),
                  _buildTextField(_usernameController, "Usuario"),
                  const SizedBox(height: 16),
                  _buildTextField(_passwordController, "Contraseña", isPassword: true),
                  const SizedBox(height: 24),
                  if (_errorMessage.isNotEmpty)
                    Text(_errorMessage, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD8B47C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: Colors.brown),
                            ),
                          ),
                          onPressed: _handleLogin,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            child: Text(
                              "Ingresar",
                              style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/register'),
                    child: const Text(
                      "¿No tienes una cuenta? Regístrate",
                      style: TextStyle(color: Colors.lightBlue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.brown),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.brown, width: 2),
        ),
      ),
      validator: (value) => (value == null || value.isEmpty) ? 'Campo obligatorio' : null,
    );
  }
}