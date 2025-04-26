import 'package:flutter/material.dart';
import 'package:eventwine/feature/register_and_login/presentation/pages/register_page.dart';
import 'package:eventwine/feature/register_and_login/presentation/pages/login_page.dart';
import 'package:eventwine/feature/home/presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Galpon App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),	
      },
    );
  }
}
