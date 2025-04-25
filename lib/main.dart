import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:eventwine/feature/register_and_login/presentation/pages/register_page.dart';
import 'package:eventwine/feature/register_and_login/presentation/pages/login_page.dart';
import 'package:eventwine/feature/home/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EventWine',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(),	
      },
    );
  }
}
