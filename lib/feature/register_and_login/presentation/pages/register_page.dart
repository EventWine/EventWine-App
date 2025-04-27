import 'package:flutter/material.dart';
import 'package:eventwine/feature/register_and_login/data/remote/user_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedRole = 'Winemaker'; // Valor por defecto
  bool _isLoading = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final responseMessage = await UserService.registerUser(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
        role: _selectedRole,
      );

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseMessage)),
      );

      if (responseMessage.toLowerCase().contains('exitoso')) {
        Navigator.pop(context);
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
                  const SizedBox(height: 16),
                  _buildRoleSelector(),
                  const SizedBox(height: 24),
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
                          onPressed: _register,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            child: Text(
                              "Registrarse",
                              style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/login'),
                    child: const Text(
                      "¿Ya tienes una cuenta? Inicia sesión",
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

  Widget _buildRoleSelector() {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return ListView(
              children: [
                ListTile(
                  title: const Text('Winemaker'),
                  onTap: () {
                    setState(() {
                      _selectedRole = 'Winemaker';
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.brown),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_selectedRole, style: const TextStyle(color: Colors.black87)),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
